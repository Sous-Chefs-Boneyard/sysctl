require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'sysctl::default' do
  # Test all generic stuff on all platforms
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['sysctl_param']) do |_node|
            allow_any_instance_of(Chef::Resource).to receive(:shell_out).and_call_original
            allow_any_instance_of(Chef::Resource).to receive(:shell_out).with(/^sysctl -w .*/).and_return(double('Mixlib::ShellOut', error!: false))
          end.converge('sysctl::default')
        end

        let(:template) do
          chef_run.template('/etc/sysctl.d/99-chef-vm.swappiness.conf')
        end
      end
    end
  end
end
