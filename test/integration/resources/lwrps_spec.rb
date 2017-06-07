describe file('/proc/sys/net/ipv4/tcp_max_syn_backlog') do
  it { should be_file }
  its('content') { should match /12345/ }
end

persistence_file = case os[:family].downcase
                   when 'redhat', 'fedora', 'debian', 'ubuntu'
                     '/etc/sysctl.d/99-chef-attributes.conf'
                   else
                     '/etc/sysctl.conf'
                   end

if os[:family] == 'suse' && host_inventory['platform_version'].to_f >= 12.0
  persistence_file = '/etc/sysctl.d/99-chef-attributes.conf'
end

describe file(persistence_file) do
  it { should be_file }
  its('content') { should match /net.ipv4.tcp_max_syn_backlog=12345/ }
  its('content') { should match /vm.swappiness=19/ }
end
