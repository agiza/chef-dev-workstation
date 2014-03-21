#!/usr/bin/env bats
@test "admin user's group is created" {
  run getent group admin
  [ "$status" -eq 0 ]
}

@test "admin user is created if it doesn't exist" {
  run getent passwd admin
  [ "$status" -eq 0 ]
}

@test "admin user's dotfiles get created" {
  run test -f /home/admin/.bash_profile
}
