#!/usr/bin/env bats

# /proc/sys/net/ipv4/tcp_fin_max_syn_backlog 12345
@test "net.ipv4.tcp_max_syn_backlog was updated in /proc" {
  run cat /proc/sys/net/ipv4/tcp_max_syn_backlog
  [ "$output" -eq 12345 ]
}
