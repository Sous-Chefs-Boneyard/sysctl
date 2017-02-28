describe file('/proc/sys/dev/cdrom/autoeject') do
  it { should be_file }
  its('content') { should match /1/ }
end

describe file('/proc/sys/vm/swappiness') do
  it { should be_file }
  its('content') { should match /19/ }
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
  its('content') { should match /vm.swappiness=19/ }
  its('content') { should match /dev.cdrom.autoeject=1/ }
end
