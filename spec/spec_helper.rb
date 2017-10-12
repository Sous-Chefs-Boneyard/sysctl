require 'chefspec'
require 'chefspec/berkshelf'
require 'mixlib/shellout'

RSpec.configure do |config|
  config.formatter = :documentation
  config.color = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end

def platforms
  {
    'ubuntu' => ['14.04', '16.04'],
    'debian' => ['7.11', '8.8'],
    'fedora' => ['25'],
    'redhat' => ['6.9', '7.3'],
    'centos' => ['6.9', '7.3.1611'],
    'freebsd' => ['10.3', '11.0'],
    'suse' => ['12.2'],
  }
end
