module SysctlCookbook
  class SysctlParam < Chef::Resource
    require_relative 'helpers_param'
    include SysctlHelpers::Param

    resource_name :sysctl_param

    property :key, String, name_property: true
    property :value, [Array, String, Integer], coerce: proc { |v| coerce_value(v) }, required: true

    load_current_value do
      begin
        value get_sysctl_value(key)
      rescue
        current_value_does_not_exist!
      end
    end

    default_action :apply

    declare_action_class.class_eval do
      def whyrun_supported?
        true
      end

      def create_init
        template '/etc/rc.d/init.d/procps' do
          cookbook 'sysctl'
          source 'procps.init-rhel.erb'
          mode '0775'
          only_if { platform_family?('rhel', 'fedora', 'pld') }
        end

        s = service_type
        service 'procps' do
          service_name s['name'] if s['name']
          provider s['provider'] if s['provider']
          action :enable
        end
      end

      def create_sysctld(key, value)
        directory confd_sysctl

        template "#{confd_sysctl}/99-chef-#{key}.conf" do
          cookbook 'sysctl'
          source 'sysctl.conf.erb'
          variables(
            k: key,
            v: value
          )
          notifies :run, 'execute[combine sysctl files]', :immediately unless sysctld?
          notifies :start, 'service[procps]', :immediately if restart_procps?
        end

        execute 'combine sysctl files' do
          command "cat #{confd_sysctl}/*.conf > #{config_sysctl}"
          action :nothing
        end unless sysctld?
      end
    end

    action :apply do
      converge_if_changed do
        node.default['sysctl']['backup'][key] ||= get_sysctl_value(key)
        create_init
        create_sysctld(key, value)
        set_sysctl_param(key, value)
      end
    end

    action :remove do
      converge_by "reverting #{key}" do
        v = node['sysctl']['backup'][key]
        r = create_sysctld
        r.action(:delete)
        set_sysctl_param(key, v)
        node.rm['sysctl']['backup'][key]
      end
    end
  end
end
