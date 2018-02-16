#
# Cookbook Name:: sysctl
# Resource:: reload
#
# Copyright:: 2018, Webb Agile Solutions Ltd.
# Copyright:: 2018, Chef Software Inc.
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

action :reload do
  if node['init_package'] == 'systemd'
    service 'systemd-sysctl' do
      action :restart
    end
  else
    cookbook_file '/etc/rc.d/init.d/procps' do
      cookbook 'sysctl'
      source 'procps'
      mode '0775'
      only_if { platform_family?('rhel', 'fedora', 'pld', 'amazon') }
    end

    service 'procps' do
      supports restart: true, reload: true, status: false
      action :restart
    end
  end
end
