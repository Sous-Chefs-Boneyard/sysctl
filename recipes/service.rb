#
# Cookbook Name:: sysctl
# Recipe:: service
#
# Copyright 2013-2014, OneHealth Solutions, Inc.
#

template '/etc/rc.d/init.d/procps' do
  source 'procps.init-rhel.erb'
  mode '0755'
  only_if { platform_family?('rhel', 'pld') }
end

service 'procps' do
  supports :restart => true, :reload => true, :status => false
  action :enable
end
