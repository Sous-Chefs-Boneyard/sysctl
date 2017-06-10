name 'sysctl'
maintainer 'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
issues_url 'https://github.com/sous-chefs/sysctl/issues'
source_url 'https://github.com/sous-chefs/sysctl'
license 'Apache-2.0'
description 'Configures sysctl parameters'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.9.0'
chef_version '>= 12.5' if respond_to?(:chef_version)

supports 'ubuntu', '>= 14.04'
supports 'debian', '>= 7.0'
supports 'centos', '>= 6.0'
supports 'scientific', '>= 6.4'
supports 'suse', '>= 11.0'
supports 'redhat'
supports 'pld'

depends 'ohai', '>= 4.0'
