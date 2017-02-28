require 'spec_helper'

describe 'sysctl_test' do
  describe 'lwrps' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['sysctl_param'], platform: 'ubuntu', version: '16.04') do |node|
        node.default['sysctl']['conf_dir'] = '/etc/sysctl.d'
        node.default['sysctl']['params'] = {}
        node.default['sysctl']['allow_sysctl_conf'] = false
      end.converge 'sysctl_test::chefspec'
    end

    it 'applies a sysctl_param named net.ipv4.tcp_max_syn_backlog with value 12345' do
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_max_syn_backlog').with(value: 12_345)
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_max_syn_backlog').with(key: 'net.ipv4.tcp_max_syn_backlog')
      expect(chef_run).to_not apply_sysctl_param('net.ipv4.tcp_max_syn_backlog').with(key: nil)
    end

    it 'runs an execute sysctl[net.ipv4.tcp_max_syn_backlog]' do
      expect(chef_run).to run_execute('sysctl[net.ipv4.tcp_max_syn_backlog]').with(command: 'sysctl -w "net.ipv4.tcp_max_syn_backlog=12345"')
    end

    it 'applies a sysctl_param named net.ipv4.tcp_rmem with value "4096 16384 33554432"' do
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_rmem').with(value: '4096 16384 33554432')
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_rmem').with(key: 'net.ipv4.tcp_rmem')
      expect(chef_run).to_not apply_sysctl_param('net.ipv4.tcp_rmem').with(key: nil)
    end

    it 'runs an execute sysctl[net.ipv4.tcp_rmem]' do
      expect(chef_run).to run_execute('sysctl[net.ipv4.tcp_rmem]').with(command: 'sysctl -w "net.ipv4.tcp_rmem=4096 16384 33554432"')
    end

    it 'notifies the save-sysctl-params ruby block' do
      expect(chef_run.execute('sysctl[net.ipv4.tcp_max_syn_backlog]')).to notify('ruby_block[save-sysctl-params]').to(:run).delayed
      expect(chef_run.execute('sysctl[net.ipv4.tcp_rmem]')).to notify('ruby_block[save-sysctl-params]').to(:run).delayed
    end

    it 'notifies the config file template' do
      expect(chef_run.ruby_block('save-sysctl-params')).to notify("template[#{Sysctl.config_file(chef_run.node)}]").to(:create).delayed
    end
  end
end
