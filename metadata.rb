name 'sysctl'
maintainer 'Sander van Zoest'
maintainer_email 'sander+cookbooks@vanzoest.com'
issues_url 'https://github.com/svanzoest-cookbooks/sysctl/issues'
source_url 'https://github.com/svanzoest-cookbooks/sysctl/'
license 'Apache v2.0'
description 'Configures sysctl parameters'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.6.2'
supports 'ubuntu', '>= 12.04'
supports 'debian', '>= 7.0'
supports 'centos', '>= 5.9'
supports 'scientific', '>= 6.4'
%w(redhat pld).each do |os|
  supports os
end
conflicts 'jn_sysctl'
conflicts 'el-sysctl'
depends 'ohai'
