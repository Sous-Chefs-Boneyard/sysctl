require 'spec_helper'

describe file('/proc/sys/net/ipv4/tcp_fin_timeout') do
  it { should be_file }
  it { should contain '29' }
end

describe file('/proc/sys/vm/swappiness') do
  it { should be_file }
  it { should contain '19' }
end
