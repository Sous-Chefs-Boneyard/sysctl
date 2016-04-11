source 'https://rubygems.org'

# resolve nokogiri updates for chefdk, although it may force chefdk now
# https://github.com/chef/chef-dk/issues/278#issuecomment-89251860
ENV['PKG_CONFIG_PATH'] = '/opt/chefdk/embedded/lib/pkgconfig'

gem 'berkshelf', '~> 4.3', '>= 4.3.2'

group :unit do
  gem 'foodcritic',       '~> 6.1', '>= 6.1.1'
  gem 'rubocop',          '~> 0.38', '>= 0.38.0'
  gem 'chefspec',         '~> 4.6', '>= 4.6.1'
  gem 'serverspec',       '~> 2.31', '>= 2.31.1'
end

group :integration do
  gem 'test-kitchen', '~> 1.7', '>= 1.7.2'
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
  gem 'guard-foodcritic', '~> 2.1.0'
  gem 'guard-kitchen', '~> 0.0.2'
  gem 'guard-rspec', '~> 4.6', '>= 4.6.5'
  gem 'rb-fsevent', :require => false
  gem 'rb-inotify', :require => false
  gem 'terminal-notifier-guard', :require => false
  require 'rbconfig'
  if RbConfig::CONFIG['target_os'] =~ /mswin|mingw|cygwin/i
    gem 'wdm', '>= 0.1.1'
    gem 'win32console'
  end
end
