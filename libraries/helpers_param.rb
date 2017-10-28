module SysctlCookbook
  module SysctlHelpers
    module Param
      def sysctld?
        if node['sysctl'].attribute?('allow_sysctl_conf')
          return node['sysctl']['allow_sysctl_conf'] ? false : true
        end

        case node['platform_family']
        when 'freebsd'
          false
        when 'arch', 'debian', 'rhel', 'fedora', 'amazon'
          true
        when 'suse'
          node['platform_version'].to_f < 12.0 ? false : true
        end
      end

      def restart_procps?
        return true unless node['sysctl'].attribute?('restart_procps')
        node['sysctl']['restart_procps']
      end

      def config_sysctl
        return node['sysctl']['conf_file'] if node['sysctl'].attribute?('conf_file')

        case node['platform_family']
        when 'freebsd'
          '/etc/sysctl.conf.local'
        when 'suse'
          '/etc/sysctl.conf' if node['platform_version'].to_f < 12.0
        else
          raise 'Unknown sysctl file location. Unsupported platform.'
        end
      end

      def confd_sysctl
        if node['sysctl'].attribute?('conf_dir')
          node['sysctl']['conf_dir']
        else
          '/etc/sysctl.d'
        end
      end

      def get_sysctl_value(key)
        o = shell_out("sysctl -n #{'-e ' if node['sysctl']['ignore_error']}#{key}")
        raise 'Unknown sysctl key!' if o.error!
        o = o.stdout.tr("\t", ' ').strip
        raise unless o == get_sysctld_value(key)
        o
      end

      def get_sysctld_value(key)
        raise unless ::File.exist?("/etc/sysctl.d/99-chef-#{key}.conf")
        k, v = IO.read("/etc/sysctl.d/99-chef-#{key}.conf").match(/(.*) = (.*)/).captures
        raise 'Unknown sysctl key!' if k.nil?
        raise 'Unknown sysctl value!' if v.nil?
        v
      end

      def set_sysctl_param(key, value)
        o = shell_out("sysctl #{'-e ' if node['sysctl']['ignore_error']}-w \"#{key}=#{value}\"")
        return false if o.error!
        true
      end

      def coerce_attributes(a, out = nil)
        case a
        when Array
          "#{out}=#{a.join(' ')}"
        when String, Integer
          "#{out}=#{a}"
        when Hash
          out += '.' unless out.nil?
          a.map { |k, v| coerce_attributes(v, "#{out}#{k}") }.flatten.sort
        end
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
