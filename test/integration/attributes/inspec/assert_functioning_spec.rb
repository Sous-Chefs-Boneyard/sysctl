describe command('sysctl -n vm.swappiness') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^19$/) }
end

describe file('/etc/sysctl.d/99-chef-vm.swappiness.conf') do
  it { should be_file }
end

describe command('sysctl -n net.ipv4.tcp_fin_timeout') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^29$/) }
end

describe file('/etc/sysctl.d/99-chef-net.ipv4.tcp_fin_timeout.conf') do
  it { should be_file }
end

describe command('sysctl -n net.ipv4.tcp_wmem') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^4096\t16384\t3825664$/) }
end

describe file('/etc/sysctl.d/99-chef-net.ipv4.tcp_wmem.conf') do
  it { should be_file }
end
