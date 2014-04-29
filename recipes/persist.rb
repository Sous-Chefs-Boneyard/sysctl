#
# Cookbook Name:: sysctl
# Recipe:: persist
#
# This file is in the public domain.
#

include_recipe 'sysctl::default'

ruby_block 'persist sysctl variables' do
  block do
  end
  notifies :run, 'ruby_block[save-sysctl-params]'
end
