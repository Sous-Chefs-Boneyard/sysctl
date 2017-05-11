require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'sysctl::apply' do
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
