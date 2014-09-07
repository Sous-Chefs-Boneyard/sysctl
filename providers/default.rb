require 'shellwords'

include Chef::Mixin::ShellOut

class << self
  attr_accessor :buffer, :writer
end

# chef stuff

def whyrun_supported?
  true
end

def define_resource_requirements
  requirements.assert(:apply, :remove) do |a|
    a.assertion { new_resource.parameters }
    a.failure_message Chef::Exceptions::ValidationFailed,
                      'Required argument parameters is missing!'
  end
  requirements.assert(:apply) do |a|
    a.assertion { new_resource.parameters.is_a? Hash }
    a.failure_message Chef::Exceptions::ValidationFailed,
                      'Option parameters must be a kind of Hash!  ' \
                      "You passed #{new_resource.parameters.inspect}."
  end
end

def load_current_resource
  @current_resource = new_resource.class.new(new_resource.name)
  return if parameters.empty?
  current_state = shell_out("#{command} #{parameters.keys.shelljoin}")
  if current_state.error?
    fail Mixlib::ShellOut::ShellCommandFailed,
         current_state.stderr.sub('error: ', '')
  end
  @current_resource.parameters parse(current_state.stdout)
end

# actions

def action_apply
  parameters.each do |k, v|
    apply(k, v)
  end
  buffer.merge! parameters
  new_resource.notifies_delayed :save, writer if config
end

def action_remove
  parameters.each do |k, _|
    restore(k)
    buffer.delete(k)
  end
  new_resource.notifies_delayed :save, writer if config
end

def action_save
  action_apply if parameters
  return unless config
  config.content buffer.map { |k, v| "#{k} = #{v}\n" } .sort.join
  config.run_action :create
  return if resource_updated?
  new_resource.updated_by_last_action config.updated_by_last_action?
end

# accessors

def buffer
  self.class.buffer ||=
    if config && ::File.exist?(config.path)
      parse ::File.read config.path
    else
      {}
    end
end

def command
  @command ||=
    case
    when platform_family?('freebsd')
      'sysctl -e'
    else
      'sysctl'
    end
end

def config
  return false if @config == false
  @config ||= begin
    path =
      case
      when node.sysctl.conf_file
        node.sysctl.conf_file
      when node.sysctl.allow_sysctl_conf
        '/etc/sysctl.conf'
      end
    path ? Chef::Resource::File.new(path, run_context) : false
  end
end

def parameters
  @parameters ||=
    case new_resource.parameters
    when Array
      validate! Hash[new_resource.parameters.map { |k| [k, nil] }]
    when Hash
      validate! flatten new_resource.parameters
    else
      {}
    end
end

def path
  @path ||= Chef::Config[:file_backup_path].to_s
end

def writer
  self.class.writer ||= Chef::Resource::Sysctl.new('writer', run_context)
end

# helpers

def apply(key, value)
  file = cache(key)
  return unless sysctl(key, value)
  converge_by("create cache for #{key}") do
    FileUtils.mkdir_p(::File.dirname(file))
    ::File.write(file, @current_resource.parameters[key])
  end unless ::File.exist?(file)
end

def cache(key)
  ::File.join(path, 'proc', 'sys', key.tr('/.', './'))
end

def flatten(value, prefix = [])
  case value
  when Hash
    value.map { |k, v| flatten(v, prefix.dup << k) } .reduce({}, &:merge)
  else
    { prefix.join('.') => stringify(value) }
  end
end

def parse(input)
  input.lines.reduce(Hash.new) do |hash, line|
    key, value = line.split('=', 2).map(&:strip)
    value = "#{hash[key]}\n#{value}" if hash.key? key
    value ? hash.update(key => value) : hash
  end
end

def restore(key)
  file = cache(key)
  return unless ::File.exist?(file)
  sysctl(key, ::File.read(file))
  converge_by("remove cache for #{key}") do
    ::File.unlink(file)
  end
end

def stringify(value)
  case value
  when Array
    value.join("\t")
  when Numeric, Symbol
    value.to_s
  when String
    value =~ /^[\d\s]+$/ ? stringify(value.split(/\s+/)) : value
  else
    fail Chef::Exceptions::ValidationFailed,
         "Option parameters contains an unsupported data type: #{value.class}"
  end
end

def sysctl(key, value)
  converge_by("set #{key} = #{value}") do
    shell_out!("sysctl #{key.shellescape}=#{value.shellescape}")
  end unless value == @current_resource.parameters[key]
end

def validate!(input)
  key = input.find { |k, _| !(k =~ /^[a-z0-9][a-z0-9_\.\-\/]*$/) }
  return input unless key
  fail Chef::Exceptions::ValidationFailed,
       "Option parameters contains an invalid key: #{key}"
end
