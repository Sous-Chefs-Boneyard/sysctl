#
# Cookbook Name:: sysctl
# Recipe:: default
#
# Copyright 2011, Fewbytes Technologies LTD
# Copyright 2012, Chris Roberts <chrisroberts.code@gmail.com>
#

service "procps"

sysctl_path = if(node[:sysctl][:conf_dir])
                File.join(node[:sysctl][:conf_dir], '99-chef-attributes.conf')
              else
                node[:sysctl][:allow_sysctl_conf] ? '/etc/sysctl.conf' : nil
              end

if(sysctl_path)
  template sysctl_path do
    action :nothing
    source 'sysctl.conf.erb'
    mode '0644'
    notifies :start, resources(:service => 'procps'), :immediately
    only_if do
      node[:sysctl][:attributes] && !node[:sysctl][:attributes].empty?
    end
  end

  ruby_block 'sysctl config notifier' do
    block do
      true
    end
    notifies :create, resources(:template => sysctl_path), :delayed
  end
end

