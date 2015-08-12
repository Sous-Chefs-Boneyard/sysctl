require 'spec_helper'

describe file('/proc/sys/net/ipv4/tcp_fin_timeout') do
  it { should be_file }
  it { should contain '29' }
end

describe file('/proc/sys/vm/swappiness') do
  it { should be_file }
  it { should contain '19' }
end

persistence_file = case os[:family].downcase
                   when 'redhat', 'fedora', 'debian', 'ubuntu'
                     '/etc/sysctl.d/99-chef-attributes.conf'
                   else
                     '/etc/sysctl.conf'
                   end

if os[:family] == 'suse' && host_inventory['platform_version'].to_f >= 12.0
  persistence_file = '/etc/sysctl.d/99-chef-attributes.conf'
end

describe file(persistence_file) do
  it { should be_file }
  it { should contain 'vm.swappiness=19' }
  it { should contain 'net.ipv4.tcp_fin_timeout=29' }
end
