#
# Cookbook Name:: sysctl
# Recipe:: service
#
# Copyright 2013-2014, OneHealth Solutions, Inc.
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

template '/etc/rc.d/init.d/procps' do
  source 'procps.init-rhel.erb'
  mode '0755'
  only_if { platform_family?('rhel', 'fedora', 'pld') }
end

service 'procps' do
  supports :restart => true, :reload => true, :status => false
  action :enable
end
