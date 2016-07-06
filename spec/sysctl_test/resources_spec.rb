require 'spec_helper'

describe 'sysctl_test::resources' do
  cached(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  context 'testing apply action' do
    it 'apply sysctl_param[net.ipv4.tcp_max_syn_backlog]' do
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_max_syn_backlog').with(
        value: '12345'
      )
    end

    it 'apply sysctl_param[net.ipv4.tcp_rmem]' do
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_rmem').with(
        value: '4096 16384 33554432'
      )
    end

    it 'apply sysctl_param[net.ipv4.tcp_mem]' do
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_mem').with(
        value: '44832 59776 179328'
      )
    end
  end
end
