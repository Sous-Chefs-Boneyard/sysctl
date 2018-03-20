if (os[:family] == 'redhat' && os[:release].start_with?('6')) || os[:name] == 'amazon' || os[:family] == 'suse'

  describe command('sysctl -n kernel.msgmax') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/^65536$/) }
  end

else

  describe command('sysctl -n kernel.msgmax') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/^8192$/) }
  end

end

describe file('/etc/sysctl.d/99-chef-kernel.msgmax.conf') do
  it { should_not be_file }
end

describe command('sysctl -n vm.swappiness') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^19$/) }
end
