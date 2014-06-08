require 'spec_helper'

describe_kernel_parameter 'net.core.somaxconn', 2048
describe_kernel_parameter 'net.ipv4.tcp_keepalive_time', 10_800
describe_kernel_parameter 'net.ipv4.tcp_max_syn_backlog', 12_345
describe_kernel_parameter 'net.ipv4.tcp_rmem', "4096\t16384\t33554432"
describe_kernel_parameter 'net.ipv4.tcp_wmem', "1024\t32768\t33554432"
describe_kernel_parameter 'net.ipv6.icmp.ratelimit', 2000

persistence_file =
  case os[:family]
  when 'Debian', 'Fedora', 'RedHat', 'Ubuntu'
    '/etc/sysctl.d/99-chef-managed.conf'
  else
    '/etc/sysctl.conf'
  end

describe file(persistence_file) do
  it { should be_file }
  it { should contain 'net.core.somaxconn = 2048' }
  it { should contain 'net.ipv4.tcp_keepalive_time = 10800' }
  it { should contain 'net.ipv4.tcp_max_syn_backlog = 12345' }
  it { should contain "net.ipv4.tcp_rmem = 4096\t16384\t33554432" }
  it { should contain "net.ipv4.tcp_wmem = 1024\t32768\t33554432" }
  it { should contain 'net.ipv6.icmp.ratelimit = 2000' }
end
