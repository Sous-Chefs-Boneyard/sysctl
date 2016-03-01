require 'spec_helper'

describe file('/proc/sys/net/ipv4/tcp_max_syn_backlog') do
  it { should be_file }
  it { should contain '12345' }
end

describe file('/proc/sys/net/ipv4/tcp_rmem') do
  it { should be_file }
  it { should contain '4096	16384	33554432' }
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
  it { should contain 'net.ipv4.tcp_max_syn_backlog=12345' }
  it { should contain 'net.ipv4.tcp_rmem=4096 16384 33554432' }
  it { should contain 'net.ipv4.tcp_wmem=1024 32768 33554432' }
end
