describe command('sysctl -n vm.swappiness') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^19$/) }
end

describe file('/etc/sysctl.d/99-chef-vm.swappiness.conf') do
  it { should be_file }
  its(:content) { should match /^vm.swappiness = 19$/ }
end

describe command('sysctl -n dev.cdrom.autoeject') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^1$/) }
end

describe file('/etc/sysctl.d/99-chef-dev.cdrom.autoeject.conf') do
  it { should be_file }
  its(:content) { should match /^dev.cdrom.autoeject = 1$/ }
end
