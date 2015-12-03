source 'https://rubygems.org'

# for nokogiri gem, can be removed
ENV['PKG_CONFIG_PATH'] = '/opt/chefdk/embedded/lib/pkgconfig'

gem 'berkshelf',  '~> 4.0.1'

group :unit do
  gem 'foodcritic',       '~> 5.0'
  gem 'rubocop',          '~> 0.35.1', '>= 0.35.1'
  gem 'chefspec',         '~> 4.4.0'
end

group :integration do
  gem 'test-kitchen', '~> 1.4.2'
  gem 'kitchen-vagrant', :require => false
  gem 'kitchen-digitalocean', :require => false
  gem 'kitchen-ec2', :require => false
end

group :release do
  gem 'rspec_junit_formatter'
  gem 'rubocop-checkstyle_formatter'
end

group :development do
  gem 'guard', '~> 2.13.0'
  gem 'guard-rubocop', '~> 1.2.0'
  gem 'guard-foodcritic', '~> 2.0.0'
  gem 'guard-kitchen', '~> 0.0.2'
  gem 'guard-rspec', '~> 4.6.4'
  gem 'rb-fsevent', :require => false
  gem 'rb-inotify', :require => false
  gem 'terminal-notifier-guard', :require => false
  require 'rbconfig'
  if RbConfig::CONFIG['target_os'] =~ /mswin|mingw|cygwin/i
    gem 'wdm', '>= 0.1.0'
    gem 'win32console'
  end
end
