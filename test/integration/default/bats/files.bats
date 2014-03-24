#!/usr/bin/env bats

@test "Admin user's bash_profile is created." {
  run test -f /home/admin/.bash_profile
  [ "$status" -eq 0 ]
}

@test "Admin user's .vim directory is created." {
  run test -d /home/admin/.vim
  [ "$status" -eq 0 ]
}
