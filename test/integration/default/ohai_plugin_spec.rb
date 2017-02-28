describe bash('/opt/chef/embedded/bin/ohai -d /opt/kitchen/ohai/plugins/ sys') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match %r("net": {) }
end
