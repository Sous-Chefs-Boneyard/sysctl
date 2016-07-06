sysctl_param 'net.ipv4.tcp_max_syn_backlog' do
  value 12345
end

sysctl_param 'net.ipv4.tcp_rmem' do
  value '4096 16384 33554432'
end

sysctl_param 'net.ipv4.tcp_mem' do
  value [44832, 59776, 179328]
end
