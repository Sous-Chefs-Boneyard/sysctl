require 'spec_helper'

describe command('ohai -d /etc/chef/ohai_plugins sys') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match %r("net": {) }
end
