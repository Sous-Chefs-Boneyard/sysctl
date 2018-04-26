if (os[:family] == 'redhat' && os[:release].start_with?('6')) || os[:name] == 'amazon'

  describe kernel_parameter('kernel.msgmax') do
    its('value') { should eq 65536 }
  end

else

  describe kernel_parameter('kernel.msgmax') do
    its('value') { should eq 8192 }
  end

end

describe file('/etc/sysctl.d/99-chef-kernel.msgmax.conf') do
  it { should_not be_file }
end

describe kernel_parameter('vm.swappiness') do
  its('value') { should eq 19 }
end

describe file('/etc/sysctl.d/99-chef-bogus.sysctl_val2.conf') do
  its('content') { should eq 'bogus.sysctl_val2 = 1234' }
end
