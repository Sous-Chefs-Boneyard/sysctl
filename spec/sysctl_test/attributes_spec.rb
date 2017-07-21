require 'spec_helper'

describe 'test::attributes' do
  cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  context 'testing apply action' do
    it 'apply sysctl_param[vm.swappiness]' do
      expect(chef_run).to apply_sysctl_param('vm.swappiness').with(
        value: '19'
      )
    end

    it 'apply sysctl_param[dev.cdrom.autoeject]' do
      expect(chef_run).to apply_sysctl_param('dev.cdrom.autoeject').with(
        value: '1'
      )
    end
  end
end
