require 'spec_helper'

describe command('ohai -d /etc/chef/ohai_plugins sys') do
  it { should return_exit_status 0 }
  it { should return_stdout(/"net": {/) }
end
