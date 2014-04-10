#!/usr/bin/env bats

@test "Admin user's group is created." {
  run getent group vagrant
  [ "$status" -eq 0 ]
}

@test "Admin user is created if it doesn't exist." {
  run getent passwd vagrant
  [ "$status" -eq 0 ]
}

@test "Admin user has sudo rights on the system." {
  run grep vagrant /etc/sudoers
  [ "$status" -eq 0 ]
}
