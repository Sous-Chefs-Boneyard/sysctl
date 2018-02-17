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
property :key, String, name_property: true
property :ignore_error, [true, false], default: false
property :value, [Array, String, Integer], coerce: proc { |v| coerce_value(v) }, required: true
property :conf_dir, String, default: '/etc/sysctl.d'
property :conf_file, [String, nil], default: lazy {
  case node['platform_family']
  when 'freebsd'
    '/etc/sysctl.conf.local'
  when 'suse'
    '/etc/sysctl.conf' if node['platform_version'].to_f < 12.0
  else
    nil
  end
}
property :restart_procps, [true, false], default: true

include SysctlCookbook::SysctlHelpers::Param

load_current_value do
  value get_sysctl_value(key)
  if node.default['sysctl']['backup'][key].empty?
    node.default['sysctl']['backup'][key] = value
  end
end

action :apply do
  converge_if_changed do
    if new_resource.conf_file.nil?
      directory new_resource.conf_dir

      template "#{new_resource.conf_dir}/99-chef-#{new_resource.key}.conf" do
        cookbook 'sysctl'
        source 'sysctl.conf.erb'
        variables(key: new_resource.key, value: new_resource.value)
      end

      set_sysctl_param(new_resource.key, new_resource.value)

    else
      Chef::Log.fatal 'sysctl.d directory not found. Distro not currently supported by sysctl'
    end

    execute 'sysctl -p' do
      command 'sysctl -p'
      action :run
    end
  end
end

action :remove do
  puts node.default['sysctl']['backup'][new_resource.key]

  converge_by "removing #{new_resource.key}" do
    file "#{new_resource.conf_dir}/99-chef-#{new_resource.key}.conf" do
      action :delete
    end

    backup_value = node['sysctl']['backup'][new_resource.key]
    set_sysctl_param(new_resource.key, backup_value) unless backup_value.empty?
    node.rm('sysctl', 'backup', new_resource.key)

    execute 'sysctl -p' do
      command 'sysctl -p'
      action :run
    end
  end

  sysctl_reload 'reload'
end

action_class do
  include SysctlCookbook::SysctlHelpers::Param
end
