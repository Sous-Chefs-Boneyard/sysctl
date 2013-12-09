source "https://rubygems.org"

gem 'berkshelf',  '~> 2.0'
gem 'foodcritic', '~> 3.0'
gem 'thor-foodcritic', '~> 1.1'
gem 'rubocop',    '~> 0.12'

group :integration do
  gem 'test-kitchen',    '~> 1.1'
  gem 'kitchen-vagrant'
end

group :development do
  gem 'guard'
  gem 'guard-rubocop'
  gem 'guard-foodcritic'
  gem 'rb-fsevent', :require => false
  gem 'rb-inotify', :require => false
end
