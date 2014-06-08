require 'spec_helper'

describe 'sysctl::default' do
  multiplatform do |platform, version|
    context "on #{platform.capitalize} #{version}" do
      let(:params) { { 'vm' => { 'swappiness' => 19 } } }
      let(:chef_run) do
        ChefSpec::Runner.new(platform: platform, version: version) do |node|
          node.set['sysctl']['conf_dir'] = '/etc/sysctl.d'
          node.set['sysctl']['params'] = params
        end.converge('sysctl::default')
      end

      it 'includes the service recipe' do
        expect(chef_run).to include_recipe('sysctl::service')
      end

      it 'creates node.sysctl.conf_dir directory' do
        expect(chef_run).to create_directory(
          platform == 'freebsd' ? '/etc' : '/etc/sysctl.d'
        )
      end

      it 'calls lwrp with node.sysctl.params' do
        expect(chef_run).to apply_sysctl('attributes').with(parameters: params)
      end
    end
  end
end
