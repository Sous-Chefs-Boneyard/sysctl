require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'sysctl::service' do
  platforms = {
    'ubuntu' => ['12.04', '14.04'],
    'debian' => ['7.0', '7.4'],
    'fedora' => %w(18 20),
    'redhat' => ['6.5', '7.0'],
    'centos' => ['6.5', '7.0'],
    'freebsd' => ['9.2']
  }

  # Test all generic stuff on all platforms
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.set['sysctl']['conf_dir'] = '/etc/sysctl.d'
          runner.node.set['sysctl']['params'] = {
            'vm' => {
              'swappiness' => 19
            },
            'net' => {
              'ipv4' => {
                'tcp_fin_timeout' => 29
              }
            }
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
