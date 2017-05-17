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
            node.override['sysctl']['restart_procps'] = false
          end.converge('sysctl::default')
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
        it 'should not restart procps if restart_procps is false' do
          expect(template).to_not notify('service[procps]').immediately if expect(chef_run.node['sysctl']['restart_procps']).to be false
        end
      end
    end
  end
end
