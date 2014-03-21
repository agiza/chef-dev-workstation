#!/usr/bin/env bats
@test "admin user's group is created" {
  run getent group admin
  [ "$status" -eq 0 ]
}
