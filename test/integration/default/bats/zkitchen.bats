#!/usr/bin/env bats

@test "We can go one level deeper" {
  run git clone https://github.com/scarolan/chef-dev-workstation; cd chef-dev-workstation; berks install; strainer test
  [ "$status" -eq 0 ]
}
