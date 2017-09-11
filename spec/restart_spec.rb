require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'sysctl::default' do
  platforms = {
    'ubuntu' => ['14.04', '16.04'],
    'debian' => ['7.11', '8.8'],
    'fedora' => ['25'],
    'redhat' => ['6.9', '7.3'],
    'centos' => ['6.9', '7.3.1611'],
    'freebsd' => ['10.3', '11.0'],
    'suse' => ['12.2'],
  }

  # Test all generic stuff on all platforms
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        before do
          @restart_procps = false
        end

        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['sysctl_param']) do |node|
            node.override['sysctl']['restart_procps'] = @restart_procps
            node.default['sysctl']['params']['vm']['swappiness'] = 90
            allow_any_instance_of(Chef::Resource).to receive(:shell_out).and_call_original
            allow_any_instance_of(Chef::Resource).to receive(:shell_out).with(/^sysctl -w .*/).and_return(double('Mixlib::ShellOut', error!: false))
          end.converge('sysctl::default')
        end

        let(:template) do
          chef_run.template('/etc/sysctl.d/99-chef-vm.swappiness.conf')
        end

        it 'should not restart procps if restart_procps is false' do
          @restart_procps = false
          expect(template).to_not notify('service[procps]').immediately
        end

        it 'should start procps if restart_procps is true' do
          @restart_procps = true
          expect(template).to notify('service[procps]').to(:start).immediately
          if platform == 'freebsd'
            expect(template).to notify('execute[combine sysctl files]').to(:run).immediately
          end
        end
      end
    end
  end
end
