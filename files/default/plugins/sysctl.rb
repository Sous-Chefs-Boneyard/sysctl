#
# Author:: Sander van Zoest (<svanzoest@onehealth.com>)
# Copyright:: Copyright (c) 2014 OneHealth Solutions, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'chef/mixin/deep_merge'

Ohai.plugin(:Sysctl) do
  provides "sysctl"

  def init_sysctl
    sysctl Mash.new
    sysctl
  end

  def get_sysctls(cmd='sysctl -A')
    so = shell_out(cmd)
    sys_attrs = Mash.new
    so.stdout.lines do |line|
      k,v = line.split(%r{[=:]})
      next if k == nil || v == nil
      k = k.strip
      v = v.strip
      key_path = k.split('.')
      attrs = Mash.new
      location = key_path.slice(0, key_path.size - 1).reduce(attrs) do |m, o|
        m[o] ||= {}
        m[o]
      end
      location[key_path.last] = v
      sys_attrs = Chef::Mixin::DeepMerge.merge(sys_attrs, attrs)
    end
    sys_attrs
  end

  collect_data(:default) do
    sysctl init_syctl
  end
 
  collect_data(:linux) do
    sysctl init_sysctl
    sysctl.merge get_sysctls
  end

  collect_data(:darwin) do
    sysctl init_sysctl 
    sysctl.merge get_sysctls
  end
end
