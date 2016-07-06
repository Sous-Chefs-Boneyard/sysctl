require 'spec_helper'

describe 'sysctl_test::attributes' do
  cached(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  context 'testing apply action' do
    it 'apply sysctl_param[vm.swappiness]' do
      expect(chef_run).to apply_sysctl_param('vm.swappiness').with(
        value: '19'
      )
    end

    it 'apply sysctl_param[net.ipv4.tcp_fin_timeout]' do
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_fin_timeout').with(
        value: '29'
      )
    end

    it 'apply sysctl_param[net.ipv4.tcp_wmem]' do
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_wmem').with(
        value: '4096 16384 3825664'
      )
    end
  end
end
