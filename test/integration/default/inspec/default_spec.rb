if (os[:family] == 'redhat' && os[:release].start_with?('6')) || os[:name] == 'amazon' || os[:family] == 'suse'

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
