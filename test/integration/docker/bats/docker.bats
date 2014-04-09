#!/usr/bin/env bats

@test "Docker is installed." {
  run su - vagrant -c "docker --version"
  [ "$status" -eq 0 ]
}
