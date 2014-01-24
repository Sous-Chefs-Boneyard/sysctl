source 'https://rubygems.org'

gem 'berkshelf', '~> 2.0.13'

group :integration do
  gem 'test-kitchen',    '~> 1.1'
  gem 'kitchen-vagrant'
end

group :release do
  gem 'stove', '~> 1.1'
end

group :development do
  gem 'parser', '~> 2.1.1'
  gem 'foodcritic',       '~> 3.0'
  gem 'rubocop',          '~> 0.16.0'
  gem 'chefspec',         '~> 3.1.4'
  gem 'guard',            '~> 1.8'
  gem 'guard-rubocop',    '~> 0.2'
  gem 'guard-foodcritic', '~> 1.0'
  gem 'guard-kitchen',    '~> 0.0'
  gem 'guard-rspec',      '~> 3.0'
  gem 'rb-fsevent', :require => false
  gem 'rb-inotify', :require => false
end
