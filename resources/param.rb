
property :key, String, name_property: true
property :ignore_error, [true, false], default: false
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
    value get_sysctl_value(key)
    if node.default['sysctl']['backup'][key].empty?
      node.default['sysctl']['backup'][key] = value
    end
    node.save
end

action :apply do
  converge_if_changed do
    directory new_resource.conf_dir

    template "#{new_resource.conf_dir}/99-chef-#{new_resource.key}.conf" do
      cookbook 'sysctl'
      source 'sysctl.conf.erb'
      variables(key: new_resource.key, value: new_resource.value)
      # notifies :start, 'service[procps]', :immediately if new_resource.restart_procps
    end

    Chef::Log.fatal 'sysctl.d directory not found. Distro not supported by sysctl' unless ::File.exist?(new_resource.conf_dir)

    set_sysctl_param(new_resource.key, new_resource.value)

    execute 'sysctl --system' do
      command 'sysctl --system'
      action :run
    end
  end
end

action :remove do
  puts node.default['sysctl']['backup'][new_resource.key]

  converge_by "removing #{new_resource.key}" do
    file "#{new_resource.conf_dir}/99-chef-#{new_resource.key}.conf" do
      action :delete
    end

    backup_value = node['sysctl']['backup'][new_resource.key]
    set_sysctl_param(new_resource.key, backup_value) unless backup_value.empty?
    node.rm('sysctl', 'backup', new_resource.key)
    node.save

    execute 'sysctl --system' do
      command 'sysctl --system'
      action :run
    end

  end

  sysctl_reload 'reload'
end

action_class do
  include SysctlCookbook::SysctlHelpers::Param
end
