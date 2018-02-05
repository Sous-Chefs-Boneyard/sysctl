def get_sysctl_value(key)
  value = shell_out("sysctl -n #{'-e ' if new_resource.ignore_error}")
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
