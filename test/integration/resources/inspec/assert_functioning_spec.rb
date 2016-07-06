describe command('sysctl -n net.ipv4.tcp_max_syn_backlog') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^12345$/) }
end

describe file('/etc/sysctl.d/99-chef-net.ipv4.tcp_max_syn_backlog.conf') do
  it { should be_file }
end

describe command('sysctl -n net.ipv4.tcp_rmem') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^4096\t16384\t33554432$/) }
end

describe file('/etc/sysctl.d/99-chef-net.ipv4.tcp_rmem.conf') do
  it { should be_file }
end

describe command('sysctl -n net.ipv4.tcp_mem') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^44832\t59776\t179328$/) }
end

describe file('/etc/sysctl.d/99-chef-net.ipv4.tcp_mem.conf') do
  it { should be_file }
end
