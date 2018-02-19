module SysctlCookbook
  module SysctlHelpers
    module Param
      def set_sysctl_param(key, value)
        o = shell_out("sysctl #{'-e ' if new_resource.ignore_error}-w \"#{key}=#{value}\"")
        o.error! ? false : true
      end

      def get_sysctl_value(key)
        o = shell_out("sysctl -n -e #{key}")
        raise 'Unknown sysctl key!' if o.error!
        o.stdout.to_s.tr("\t", ' ').strip
      end

      def get_sysctld_value(key)
        return nil unless ::File.exist?("/etc/sysctl.d/99-chef-#{key}.conf")
        k, v = IO.read("/etc/sysctl.d/99-chef-#{key}.conf").match(/(.*) = (.*)/).captures
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
    end
  end
end
