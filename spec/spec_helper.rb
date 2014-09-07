require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.formatter = :documentation
  config.color = true

  # Specify the path for Chef Solo to find roles (default: [ascending search])
  # config.role_path = '/var/roles'

  # Specify the Chef log_level (default: :warn)
  # config.log_level = :info

  # Specify the path to a local JSON file with Ohai data (default: nil)
  # config.path = 'ohai.json'
end

at_exit { ChefSpec::Coverage.report! }

def multiplatform
  platforms = {
    'ubuntu' => ['14.04', '12.04'],
    'debian' => ['7.4'],
    'centos' => ['6.5', '5.10'],
    'fedora' => %w(20 18),
    'freebsd' => ['9.2'],

    # The following platforms are currently unsupported by fauxhai, add
    # versions as the associated metadata is added to the fauxhai gem
    'arch' => [], # unsupported by fauxhai
    'exherbo' => [] # unsupported by fauxhai
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      yield platform, version
    end
  end
end
