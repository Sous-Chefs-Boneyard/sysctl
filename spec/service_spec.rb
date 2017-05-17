require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'sysctl::service' do
  platforms = {
    'ubuntu' => ['14.04', '16.04'],
    'debian' => ['7.11', '8.7'],
    'fedora' => ['25'],
    'redhat' => ['6.8', '7.3'],
    'centos' => ['6.8', '7.3.1611'],
    'freebsd' => ['10.3', '11.0'],
    'suse' => ['12.2'],
  }

  # Test all generic stuff on all platforms
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.default['sysctl']['conf_dir'] = '/etc/sysctl.d'
          runner.node.default['sysctl']['params'] = {
            'vm' => {
              'swappiness' => 19,
            },
            'net' => {
              'ipv4' => {
                'tcp_fin_timeout' => 29,
              },
            },
          }
          runner.converge('sysctl::service')
        end

        if platform == 'centos' || platform == 'fedora' || platform == 'redhat'
          it 'creates a template /etc/rc.d/init.d/procps' do
            expect(chef_run).to create_template('/etc/rc.d/init.d/procps')
          end
        end

        it 'enables the procps service' do
          expect(chef_run).to enable_service('procps')
          expect(chef_run).to_not enable_service('not_procps')
        end
      end
    end
  end
end
