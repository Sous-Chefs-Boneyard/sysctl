action :reload do
  Chef::Log.warn('The sysctl_reload resource has been deprecated as it is no longer necessary to set sysctl values.')
end
