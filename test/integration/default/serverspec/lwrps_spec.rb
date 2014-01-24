require 'spec_helper'

describe file('/proc/sys/net/ipv4/tcp_max_syn_backlog') do
  it { should be_file }
  it { should contain '12345' }
end

describe file('/proc/sys/net/ipv4/tcp_rmem') do
  it { should be_file }
  it { should contain '4096	16384	33554432'}
end
