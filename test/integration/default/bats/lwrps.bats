#!/usr/bin/env bats

@test "ensure a lwrp param with a single value is set (net.ipv4.tcp_max_syn_backlog)" {
  run cat /proc/sys/net/ipv4/tcp_max_syn_backlog
  [ "$output" -eq 12345 ]
}
@test "ensure a lwrp param with a value range is set (net.ipv4.tcp_rmem)" {
  run cat /proc/sys/net/ipv4/tcp_rmem
  [ "$output" = "4096	16384	33554432" ]
}

@test "ensure a lwrp param is added to config file (net.ipv4.tcp_max_syn_backlog)" {
  run grep net.ipv4.tcp_max_syn_backlog /etc/sysctl.d/99-chef-attributes.conf
  [ "$status" -eq 0 ]
}
