#!/usr/bin/env bats

@test "Admin user's group is created." {
  run getent group admin
  [ "$status" -eq 0 ]
}

@test "Admin user is created if it doesn't exist." {
  run getent passwd admin
  [ "$status" -eq 0 ]
}

@test "Admin user has sudo rights on the system." {
  run grep admin /etc/sudoers
  [ "$status" -eq 0 ]
}
