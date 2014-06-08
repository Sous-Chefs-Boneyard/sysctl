require 'spec_helper'

describe_kernel_parameter 'debug.minidump', 0

describe file('/etc/sysctl.conf.local') do
  it { should be_file }
  it { should contain 'debug.minidump = 0' }
end
