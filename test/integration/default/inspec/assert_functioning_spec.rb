describe command('sysctl -n kernel.msgmax') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^8192$/) }
end

describe file('/etc/sysctl.d/99-chef-kernel.msgmax.conf') do
  it { should_not be_file }
end

describe file('/etc/sysctl.d/99-chef-vm.swappiness.conf') do
  it { should be_file }
  its(:content) { should match /^vm.swappiness = 19$/ }
end

describe command('sysctl -n vm.swappiness') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^19$/) }
end
