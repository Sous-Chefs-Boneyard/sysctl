require 'spec_helper'

describe 'sysctl::service' do
  multiplatform do |platform, version|
    context "on #{platform.capitalize} #{version}" do
      let(:chef_run) do
        ChefSpec::Runner.new(
          platform: platform, version: version
        ).converge('sysctl::service')
      end

      if platform == 'centos' || platform == 'fedora' || platform == 'redhat'
        it 'creates a file /etc/rc.d/init.d/procps' do
          expect(chef_run).to create_cookbook_file('/etc/rc.d/init.d/procps')
        end
      end

      case platform
      when 'arch', 'exherbo'
        it 'enables the sysctl systemd service' do
          expect(chef_run).to enable_service('systemd-sysctl').with(
            provider: Chef::Provider::Service::Systemd
          )
        end
      when 'freebsd'
        it 'enables the sysctl service' do
          expect(chef_run).to enable_service('procps').with(
            service_name: 'sysctl'
          )
        end
      when 'ubuntu'
        it 'enables the procps upstart service' do
          expect(chef_run).to enable_service('procps').with(
            provider: Chef::Provider::Service::Upstart
          )
        end
      else
        it 'enables the procps service' do
          expect(chef_run).to enable_service('procps')
        end
      end
    end
  end
end
