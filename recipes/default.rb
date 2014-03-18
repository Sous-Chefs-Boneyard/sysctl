#
# Cookbook Name:: sysctl
# Recipe:: default
#
# Copyright 2011, Fewbytes Technologies LTD
# Copyright 2012, Chris Roberts <chrisroberts.code@gmail.com>
# Copyright 2013-2014, OneHealth Solutions, Inc.
#

include_recipe 'sysctl::service'

if node['sysctl']['conf_dir']
  directory node['sysctl']['conf_dir'] do
    owner 'root'
    group 'root'
    mode 0755
    action :create
  end
end

if Sysctl.config_file(node)
  # this is called by the sysctl_param lwrp to trigger template creation
  ruby_block 'save-sysctl-params' do
    action :nothing
    block do
    end
    notifies :create, "template[#{Sysctl.config_file(node)}]", :delayed
  end

  # this needs to have an action in case node.sysctl.params has changed
  # and also needs to be called for persistence on lwrp changes via the
  # ruby_block
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
