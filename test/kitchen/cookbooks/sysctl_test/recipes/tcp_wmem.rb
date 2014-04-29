#
# Cookbook Name:: test_sysctl
# Recipe:: tcp_wmem
#
# Copyright (C) 2014 Zendesk Inc.
#
# This file is in the public domain.
#
include_recipe "sysctl"

sysctl_param 'net.ipv4.tcp_wmem' do
  value "1024 32768 33554432"
end
