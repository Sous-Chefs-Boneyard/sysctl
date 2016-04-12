name 'sysctl'
maintainer 'Sander van Zoest'
maintainer_email 'sander+cookbooks@vanzoest.com'
issues_url 'https://github.com/svanzoest-cookbooks/sysctl/issues' if respond_to?(:issues_url)
source_url 'https://github.com/svanzoest-cookbooks/sysctl/' if respond_to?(:source_url)
license 'Apache v2.0'
description 'Configures sysctl parameters'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.7.5'
supports 'ubuntu', '>= 12.04'
supports 'debian', '>= 7.0'
supports 'centos', '>= 5.9'
supports 'scientific', '>= 6.4'
supports 'suse', '>= 11.0'
%w(redhat pld).each do |os|
  supports os
end
conflicts 'jn_sysctl'
conflicts 'el-sysctl'
depends 'ohai', '~> 3.0'
