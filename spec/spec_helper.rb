require 'chefspec'
require 'chefspec/berkshelf'

Berkshelf.ui.mute do
  berksfile = Berkshelf::Berksfile.from_file('Berksfile')
  berksfile.install(path: 'vendor/cookbooks')
end

RSpec.configure do |config|
  config.formatter = :documentation
  config.color_enabled = true
  # Specify the path for Chef Solo to find cookbooks (default: [inferred from
  # the location of the calling spec file])
  config.cookbook_path = %W(#{File.expand_path(Dir.pwd)}/test/kitchen/cookbooks #{File.expand_path(Dir.pwd)}/vendor/cookbooks)

  # Specify the path for Chef Solo to find roles (default: [ascending search])
  # config.role_path = '/var/roles'

  # Specify the Chef log_level (default: :warn)
  # config.log_level = :info

  # Specify the path to a local JSON file with Ohai data (default: nil)
  # config.path = 'ohai.json'
end

at_exit { ChefSpec::Coverage.report! }
