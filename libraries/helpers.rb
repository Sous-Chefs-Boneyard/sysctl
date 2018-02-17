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
    end
  end
end
