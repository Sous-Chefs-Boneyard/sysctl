#
# Cookbook Name:: test_sysctl
# Attributes:: default
#
# Copyright 2013-2014, OneHealth Solutions, Inc.
# Copyright 2014, Viverae, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe 'sysctl'

sysctl_param 'net.ipv4.tcp_max_syn_backlog' do
  value 12_345
end

sysctl_param 'net.ipv4.tcp_rmem' do
  value '4096 16384 33554432'
end

# remove sysctl parameter and set net.ipv4.tcp_fin_timeout back to default
# sysctl_param 'net.ipv4.tcp_fin_timeout' do
#  action :remove
# end
