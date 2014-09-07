require 'spec_helper'

describe_kernel_parameter 'net.ipv4.tcp_wmem', "1024\t32768\t33554432"
describe_kernel_parameter 'vm.swappiness', 23

persistence_file =
  case os[:family]
  when 'Debian', 'Fedora', 'RedHat', 'Ubuntu'
    '/etc/sysctl.d/99-chef-managed.conf'
  else
    '/etc/sysctl.conf'
  end

describe file(persistence_file) do
  it { should be_file }
  it { should contain "net.ipv4.tcp_wmem = 1024\t32768\t33554432" }
  it { should contain 'vm.swappiness = 23' }
end
