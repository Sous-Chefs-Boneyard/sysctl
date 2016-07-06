require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.formatter = :documentation
  config.color = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
