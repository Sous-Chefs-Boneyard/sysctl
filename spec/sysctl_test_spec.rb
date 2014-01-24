require 'spec_helper'

describe "sysctl_test" do
  describe "lwrps" do
    chef_run = ChefSpec::Runner.new(step_into: ['sysctl_param'])
    chef_run.converge "sysctl_test"

    it 'applies a sysctl_param named net.ipv4.tcp_max_syn_backlog with value 12345' do
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_max_syn_backlog').with(value: 12345)
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_max_syn_backlog').with(key: 'net.ipv4.tcp_max_syn_backlog')
      expect(chef_run).to_not apply_sysctl_param('net.ipv4.tcp_max_syn_backlog').with(key: nil)
    end

    it 'runs an execute sysctl[net.ipv4.tcp_max_syn_backlog]' do
      expect(chef_run).to run_execute('sysctl[net.ipv4.tcp_max_syn_backlog]').with(command: 'sysctl -w "net.ipv4.tcp_max_syn_backlog=12345"')
    end

    it 'applies a sysctl_param named net.ipv4.tcp_rmem with value "4096 16384 33554432"' do
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_rmem').with(value: "4096 16384 33554432")
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_rmem').with(key: 'net.ipv4.tcp_rmem')
      expect(chef_run).to_not apply_sysctl_param('net.ipv4.tcp_rmem').with(key: nil)
    end

    it 'runs an execute sysctl[net.ipv4.tcp_rmem]' do
      expect(chef_run).to run_execute('sysctl[net.ipv4.tcp_rmem]').with(command: 'sysctl -w "net.ipv4.tcp_rmem=4096 16384 33554432"')
    end


  end
end

