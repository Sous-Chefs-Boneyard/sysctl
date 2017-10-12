require 'spec_helper'

describe 'sysctl::default' do
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:fake_sysctl_value) { 90 }
        let(:fake_shellout) { instance_double('Mixlib::ShellOut', error!: false, stdout: fake_sysctl_value, live_stream: STDOUT, run_command: nil) }
        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['sysctl_param']) do |node|
            node.default['sysctl']['ignore_error'] = ignore_error
            node.default['sysctl']['params']['vm']['swappiness'] = fake_sysctl_value
            allow(Mixlib::ShellOut).to receive(:new).and_return(fake_shellout)
          end.converge('sysctl::default')
        end

        context 'when ignore_error is true' do
          let(:ignore_error) { true }

          it 'expects shell_out sysctl command with -e flag' do
            expect(Mixlib::ShellOut).to receive(:new).with(/sysctl -n -e vm.*/, anything)
            expect(Mixlib::ShellOut).to receive(:new).with(/sysctl -e -w "vm.*/, anything)
            chef_run
          end
        end

        context 'when ignore_error is false' do
          let(:ignore_error) { false }

          it 'expects shell_out sysctl command without -e flag' do
            expect(Mixlib::ShellOut).to receive(:new).with(/^sysctl -n vm.*/, anything)
            expect(Mixlib::ShellOut).to receive(:new).with(/^sysctl -w "vm.*/, anything)
            chef_run
          end
        end
      end
    end
  end
end
