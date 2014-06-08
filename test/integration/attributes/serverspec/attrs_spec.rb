require 'spec_helper'

describe_kernel_parameter 'net.ipv4.tcp_fin_timeout', 29
describe_kernel_parameter 'vm.swappiness', 19

persistence_file =
  case os[:family]
  when 'Debian', 'Fedora', 'RedHat', 'Ubuntu'
    '/etc/sysctl.d/99-chef-managed.conf'
  else
    '/etc/sysctl.conf'
  end

describe file(persistence_file) do
  it { should be_file }
  it { should contain 'net.ipv4.tcp_fin_timeout = 29' }
  it { should contain 'vm.swappiness = 19' }
end
