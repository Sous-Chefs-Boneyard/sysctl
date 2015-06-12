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

if platform?('centos') && node['platform_version'].to_f < 6
  template '/etc/rc.d/init.d/procps' do
    source 'procps.init-centos5.erb'
    mode '0755'
  end
elsif platform_family?('rhel', 'fedora', 'pld')
  template '/etc/rc.d/init.d/procps' do
    source 'procps.init-rhel.erb'
    mode '0755'
  end
end

service 'procps' do
  supports :restart => true, :reload => true, :status => false
  case node['platform']
  when 'freebsd'
    service_name 'sysctl'
  when 'arch', 'exherbo'
    service_name 'systemd-sysctl'
    provider Chef::Provider::Service::Systemd
  when 'ubuntu'
    if node['platform_version'].to_f >= 9.10
      service_name 'procps-instance' if node['platform_version'].to_f >= 14.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action :enable
end
