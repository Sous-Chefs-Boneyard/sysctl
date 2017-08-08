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

        let(:conf_dir) do
          '/etc/test.sysctl'
        end

        let(:conf_d_file) do
          ::File.join(conf_dir,'99-chef-vm.swappiness.conf')
        end

        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['sysctl_param']) do |node|
            node.override['sysctl']['conf_dir'] = conf_dir
            node.default['sysctl']['params']['vm']['swappiness'] = 90
            allow_any_instance_of(Chef::Resource).to receive(:shell_out).and_call_original
            allow_any_instance_of(Chef::Resource).to receive(:shell_out).with(/^sysctl -w .*/).and_return(double('Mixlib::ShellOut', error!: false ))
          end.converge('sysctl::default')
        end

        it 'should create the .d files in the specified location' do
          expect(chef_run).to create_template(conf_d_file)
        end
      end
    end
  end
end
