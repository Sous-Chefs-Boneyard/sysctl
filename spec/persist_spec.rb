require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'sysctl::persist' do
  platforms = {
    'ubuntu' => ['12.04', '14.04'],
    'debian' => ['7.0'],
    'centos' => ['5.9', '6.4']
  }

  # Test all generic stuff on all platforms
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          runner = ChefSpec::Runner.new(platform: platform, version: version)
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
          runner.converge('sysctl::persist')
        end

        let(:ruby_block) { chef_run.ruby_block('persist sysctl variables') }

        it 'issues a save notification' do
          expect(chef_run).to run_ruby_block('persist sysctl variables')
          expect(ruby_block).to notify('ruby_block[save-sysctl-params]').to(:run).delayed
        end
      end
    end
  end
end
