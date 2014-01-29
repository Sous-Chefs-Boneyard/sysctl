#!/usr/bin/env bats

@test "set an attribute param (net.ipv4.tcp_fin_timeout)" {
  run cat /proc/sys/net/ipv4/tcp_fin_timeout
  [ "$output" -eq 29 ]
}

@test "set a 2nd attribute param (vm.swappiness)" {
  run cat /proc/sys/vm/swappiness
  [ "$output" -eq 19 ]
}

@test "ensure an attribute param is added to config file (net.ipv4.tcp_fin_timeout)" {
  run grep net.ipv4.tcp_fin_timeout /etc/sysctl.d/99-chef-attributes.conf
  [ "$status" -eq 0 ]
}
