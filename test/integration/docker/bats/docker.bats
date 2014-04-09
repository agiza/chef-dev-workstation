#!/usr/bin/env bats

@test "Docker is installed." {
  run docker --version
  [ "$status" -eq 0 ]
}

@test "Docker can create an Ubuntu container." {
  run sudo docker run -t ubuntu grep Ubuntu /etc/lsb-release
  [ "$status" -eq 0 ]
}

@test "Docker can create a CentOS container." {
  run sudo docker run -t centos grep CentOS /etc/redhat-release
  [ "$status" -eq 0 ]
}
