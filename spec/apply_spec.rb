require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'sysctl::apply' do
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
          runner.converge('sysctl::apply')
        end

        let(:ruby_block) { chef_run.ruby_block('notify-apply-sysctl-params') }

        it 'issues a run apply-sysctl-params notification' do
          expect(chef_run).to run_ruby_block('notify-apply-sysctl-params')
          expect(ruby_block).to notify('ruby_block[apply-sysctl-params]').to(:run).immediately
        end
      end
    end
  end
end
