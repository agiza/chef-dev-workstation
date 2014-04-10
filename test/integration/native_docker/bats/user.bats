#!/usr/bin/env bats

@test "Admin user's group is created." {
  run getent group chef
  [ "$status" -eq 0 ]
}

@test "Admin user is created if it doesn't exist." {
  run getent passwd chef
  [ "$status" -eq 0 ]
}

@test "Admin user has sudo rights on the system." {
  run grep chef /etc/sudoers
  [ "$status" -eq 0 ]
}
