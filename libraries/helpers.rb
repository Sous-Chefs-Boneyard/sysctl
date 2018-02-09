module SysctlCookbook
  module SysctlHelpers
    module Param
      def set_sysctl_param(key, value)
        o = shell_out("sysctl #{'-e ' if node['sysctl']['ignore_error']}-w \"#{key}=#{value}\"")
        o.error! ? false : true
      end

      def get_sysctl_value(key)
        o = shell_out("sysctl -n #{'-e ' if new_resource.ignore_error}")
        raise 'Unknown sysctl key!' if o.error!
        value = o.stdout.tr("\t", ' ').strip
        raise unless value == get_sysctld_value(key)
        value
      end

      def get_sysctld_value(key)
        raise unless ::File.exist?("/etc/sysctl.d/99-chef-#{key}.conf")
        k, v = IO.read("/etc/sysctl.d/99-chef-#{key}.conf").match(/(.*) = (.*)/).captures
        raise 'Unknown sysctl key!' if k.nil?
        raise 'Unknown sysctl value!' if v.nil?
        v
      end

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

      def service_type
        s = {
          name: nil,
          provider: nil,
        }
        case node['platform']
        when 'freebsd'
          s['name'] = 'sysctl'
        when 'arch', 'exherbo'
          s['name'] = 'systemd-sysctl'
          s['provider'] = Chef::Provider::Service::Systemd
        when 'centos', 'redhat', 'scientific', 'oracle'
          if node['platform_version'].to_f >= 7.0
            s['name'] = 'systemd-sysctl'
            s['provider'] = Chef::Provider::Service::Systemd
          end
        when 'fedora'
          s['name'] = 'systemd-sysctl'
          s['provider'] = Chef::Provider::Service::Systemd
        when 'ubuntu'
          if node['platform_version'].to_f < 15.04
            s['provider'] = Chef::Provider::Service::Upstart
          elsif node['platform_version'].to_f >= 15.04
            s['provider'] = Chef::Provider::Service::Init::Systemd
          end
        when 'suse', 'opensuseleap'
          if node['platform_version'].to_f < 12.0
            s['name'] = 'boot.sysctl'
          elsif node['platform_version'].to_f >= 12.0
            s['name'] = 'systemd-sysctl'
            s['provider'] = Chef::Provider::Service::Systemd
          end
        end
        s
      end
    end
  end
end
