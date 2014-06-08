#
# Cookbook Name:: sysctl
# Attributes:: default
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

default.sysctl.params = {}
default.sysctl.allow_sysctl_conf = false

default.sysctl.conf_file =
  case
  when platform_family?('debian', 'fedora', 'rhel')
    '/etc/sysctl.d/99-chef-managed.conf'
  when platform_family?('freebsd')
    '/etc/sysctl.conf.local'
  end
