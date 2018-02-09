
property :key, String, name_property: true
property :value, [Array, String, Integer], coerce: proc { |v| coerce_value(v) }, required: true
property :conf_dir, String, default: '/etc/sysctl.d'
property :conf_file, [String, nil], default: lazy {
  case node['platform_family']
  when 'freebsd'
    '/etc/sysctl.conf.local'
  when 'suse'
    '/etc/sysctl.conf' if node['platform_version'].to_f < 12.0
  end
}
property :restart_procps, [true, false], default: true

include SysctlCookbook::SysctlHelpers::Param

load_current_value do
  begin
    value get_sysctl_value(key)
  rescue
    current_value_does_not_exist!
  end
end

action :apply do
  converge_if_changed do
    node.default['sysctl']['backup'][new_resource.key] ||= get_sysctl_value(new_resource.key)

    cookbook_file '/etc/rc.d/init.d/procops' do
      cookbook 'sysctl'
      source 'procops'
      mode '0775'
      only_if { platform_family?('rhel', 'fedora', 'pld', 'amazon') }
    end

    s = service_type
    service 'procps' do
      service_name s['name'] if s['name']
      provider s['provider'] if s['provider']
      action :enable
    end

    directory new_resource.conf_dir

    template "#{new_resource.conf_dir}/99-chef-#{new_resource.key}.conf" do
      cookbook 'sysctl'
      source 'sysctl.conf.erb'
      variables(key: new_resource.key, value: new_resource.value)
      notifies :start, 'service[procps]', :immediately if new_resource.restart_procps
    end

    Chef::Log.fatal 'sysctl.d directory not found. Distro not supported by sysctl' unless ::File.exist?(new_resource.conf_dir)

    set_sysctl_param(new_resource.key, new_resource.value)
  end
end

action :remove do
  converge_by "reverting #{new_resource.key}" do
    file "#{new_resource.conf_dir}/99-chef-#{new_resource.key}.conf" do
      action :delete
    end

    backup_value = node['sysctl']['backup'][new_resource.key]
    set_sysctl_param(new_resource.key, backup_value) unless backup_value.empty?
    node.rm['sysctl']['backup'][new_resource.key]
  end
end

action_class do
  include SysctlCookbook::SysctlHelpers::Param

  def coerce_value(v)
    case v
    when Array
      v.join(' ')
    when Integer
      v.to_s
    else
      v
    end
  end
end
