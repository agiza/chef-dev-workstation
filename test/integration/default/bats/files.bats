#!/usr/bin/env bats

@test "admin user's bash_profile is created" {
  run test -f /home/admin/.bash_profile
  [ "$status" -eq 0 ]
}

@test "admin user's .vim directory is created" {
  run test -d /home/admin/.vim
  [ "$status" -eq 0 ]
}
