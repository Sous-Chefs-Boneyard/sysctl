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

Ohai.plugin(:Sysctl) do
  provides 'sys'

  def parse(cmd = 'sysctl -A')
    Ohai::Log.debug("get_sysctl: running #{cmd}")
    so = shell_out(cmd)
    hash = Mash.new
    so.stdout.lines.each do |line|
      write hash, *line.split('=', 2).map(&:strip)
    end unless so.error?
    sys.update hash
  end

  # based on libraries/nested_key_hash.rb
  def write(hash, key, value)
    *path, key = key.split('.')
    hash = path.reduce(hash) do |a, b|
      a[b] = Mash.new unless a[b].is_a?(Hash)
      a[b]
    end
    hash[key] = value
  end

  collect_data(:default) do
    sys Mash.new
  end

  # customised data collectors for special case platforms
  # http://docs.opscode.com/ohai_custom.html#collect-data-blocks

  collect_data(:freebsd) do
    sys Mash.new
    parse 'sysctl -A -e'
  end

  collect_data(:linux) do
    sys Mash.new
    # this is for the benefit of CentOS 5.10 as sysctl is not in it's path
    parse 'sysctl -A || /sbin/sysctl -A'
  end

  collect_data(:darwin) do
    sys Mash.new
    parse
  end
end
