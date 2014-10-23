source 'https://rubygems.org'

gem 'berkshelf', '~> 3.1.3'

group :unit do
  gem 'foodcritic',       '~> 4.0'
  gem 'rubocop',          '~> 0.26.0'
  gem 'chefspec',         '~> 4.1'
end

group :integration do
  gem 'test-kitchen',    '~> 1.2'
  gem 'kitchen-vagrant', :require => false
  gem 'kitchen-docker', :require => false
end

group :release do
  gem 'rspec_junit_formatter'
  gem 'rubocop-checkstyle_formatter'
end

group :development do
  gem 'guard',            '~> 2.6'
  gem 'guard-rubocop',    '~> 1.1'
  gem 'guard-foodcritic', '~> 1.0'
  gem 'guard-kitchen',    '~> 0.0'
  gem 'guard-rspec',      '~> 4.2'
  gem 'rb-fsevent', :require => false
  gem 'rb-inotify', :require => false
  gem 'terminal-notifier-guard', :require => false
end
