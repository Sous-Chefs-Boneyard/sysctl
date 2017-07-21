describe command('sysctl -n vm.swappiness') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^19$/) }
end

describe file('/etc/sysctl.d/99-chef-vm.swappiness.conf') do
  it { should be_file }
  its(:content) { should match /^vm.swappiness = 19$/ }
end

describe command('sysctl -n net.ipv4.tcp_max_syn_backlog') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^4096$/) }
end

describe file('/etc/sysctl.d/99-chef-net.ipv4.tcp_max_syn_backlog.conf') do
  it { should be_file }
  its(:content) { should match /^net.ipv4.tcp_max_syn_backlog = 4096$/ }
end
