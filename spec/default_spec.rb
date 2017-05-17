require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'sysctl::default' do
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
          ChefSpec::SoloRunner.new(platform: platform, version: version) do |node|
            node.default['sysctl']['conf_dir'] = '/etc/sysctl.d'
            node.default['sysctl']['params'] = {
              'vm' => {
                'swappiness' => 19,
              },
              'net' => {
                'ipv4' => {
                  'tcp_fin_timeout' => 29,
                },
              },
            }
          end.converge('sysctl::default')
        end

        if platform != 'freebsd'
          it 'creates sysctl.conf_dir directory' do
            expect(chef_run).to create_directory('/etc/sysctl.d').with(
              user: 'root',
              group: 'root'
            )

            expect(chef_run).to_not create_directory('/etc/sysctl.d').with(
              user: 'bacon',
              group: 'fat'
            )
          end
        end

        it 'does not persist the attributes file' do
          expect(chef_run).to_not create_template('/etc/sysctl.d/99-chef-attributes.conf')
        end

        let(:template) do
          if platform == 'freebsd'
            chef_run.template('/etc/sysctl.conf.local')
          elsif platform == 'suse' && version.to_f < 12.0
            chef_run.template('/etc/sysctl.conf')
          else
            chef_run.template('/etc/sysctl.d/99-chef-attributes.conf')
          end
        end

        it 'sends a notification to the procps service' do
          expect(template).to notify('service[procps]').immediately
          expect(template).to_not notify('service[not_procps]').immediately
        end

        it 'sends the specific notification to the procps service immediately' do
          expect(template).to notify('service[procps]').to(:restart).immediately
          expect(template).to_not notify('service[procps]').to(:restart).delayed
        end
      end
    end
  end

  versions = ['5.9', '6.4']
  versions.each do |version|
    context "on Centos #{version}" do
      let(:chef_run) do
        runner = ChefSpec::SoloRunner.new(platform: 'centos', version: version)
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
        runner.converge('sysctl::default')
      end
      it 'creates a template /etc/rc.d/init.d/procps' do
        expect(chef_run).to create_template('/etc/rc.d/init.d/procps')
      end
    end
  end
end
