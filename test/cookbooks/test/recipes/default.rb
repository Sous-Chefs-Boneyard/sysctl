sysctl_param 'net.ipv4.ip_forward' do
  value 0
end

# Amazon Linux does not support vm.swappiness
sysctl_param 'vm.swappiness' do
  value 19
  ignore_error true
end

sysctl_param 'kernel.msgmax' do
  value 9000
  not_if { platform_family?('amazon') } # Amazon Linux does not handle undefined values
end

sysctl_param 'kernel.msgmax' do
  value 9000
  action :remove
end

sysctl_param 'bogus.sysctl_val' do
  value 9000
  action :remove
end

sysctl_param 'bogus.sysctl_val2' do
  value 1234
  ignore_error true
end
