source 'https://rubygems.org'

# resolve nokogiri updates for chefdk, although it may force chefdk now
# https://github.com/chef/chef-dk/issues/278#issuecomment-89251860
ENV['PKG_CONFIG_PATH'] = '/opt/chefdk/embedded/lib/pkgconfig'

gem 'berkshelf', '~> 4.3', '>= 4.3.5'

group :unit do
  gem 'foodcritic',       '~> 6.1', '>= 6.1.1'
  gem 'rubocop',          '~> 0.41', '>= 0.41.1'
  gem 'chefspec',         '~> 4.7', '>= 4.7.0'
  gem 'serverspec',       '~> 2.36', '>= 2.36.0'
end

group :integration do
  gem 'test-kitchen', '~> 1.10', '>= 1.10.0'
  gem 'kitchen-vagrant', :require => false
  gem 'kitchen-digitalocean', :require => false
  gem 'kitchen-ec2', :require => false
end

group :release do
  gem 'rspec_junit_formatter'
  gem 'rubocop-checkstyle_formatter'
end

group :development do
  ## pinned because Chef DK 0.15 is still ruby 2.1.8p440
  gem 'activesupport', '~> 4.2.6', '>= 4.2.6'
  gem 'listen', '~> 3.0', '<= 3.0.7'
  ###
  gem 'guard', '~> 2.13.0'
  gem 'guard-rubocop', '~> 1.2.0'
  gem 'guard-foodcritic', '~> 2.1.0'
  gem 'guard-kitchen', '~> 0.0.2'
  gem 'guard-rspec', '~> 4.7', '>= 4.7.2'
  gem 'rb-fsevent', :require => false
  gem 'rb-inotify', :require => false
  gem 'terminal-notifier-guard', :require => false
  require 'rbconfig'
  if RbConfig::CONFIG['target_os'] =~ /mswin|mingw|cygwin/i
    gem 'wdm', '>= 0.1.1'
    gem 'win32console'
  end
end
