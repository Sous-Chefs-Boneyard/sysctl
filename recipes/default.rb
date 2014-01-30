#
# Cookbook Name:: sysctl
# Recipe:: default
#
# Copyright 2011, Fewbytes Technologies LTD
# Copyright 2012, Chris Roberts <chrisroberts.code@gmail.com>
# Copyright 2013, OneHealth Solutions, Inc.
#

template '/etc/rc.d/init.d/procps' do
  source 'procps.init-rhel.erb'
  mode '0755'
  only_if { platform_family?('rhel', 'pld') }
end

service 'procps'

if node['sysctl']['conf_dir']
  directory node['sysctl']['conf_dir'] do
    owner 'root'
    group 'root'
    mode 0755
    action :create
  end
end

if Sysctl.config_file(node)
  template Sysctl.config_file(node) do
    action :create
    source 'sysctl.conf.erb'
    mode '0644'
    notifies :start, 'service[procps]', :immediately
    only_if do
      node['sysctl']['params'] && !node['sysctl']['params'].empty?
    end
  end
end
