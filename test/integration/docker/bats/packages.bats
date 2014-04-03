#!/usr/bin/env bats

@test "development tools are installed" {
  run gcc --version
  [ "$status" -eq 0 ]
}

@test "Test Kitchen is installed." {
    run su - admin -c "/opt/chef/embedded/bin/kitchen --version"
    [ "$status" -eq 0 ]
}

@test "Berkshelf is installed." {
    run su - admin -c "/opt/chef/embedded/bin/berks --version"
    [ "$status" -eq 0 ]
}

@test "Foodcritic is installed." {
    run su - admin -c "/opt/chef/embedded/bin/foodcritic --version"
    [ "$status" -eq 0 ]
}

@test "Rubocop is installed." {
    run su - admin -c "/opt/chef/embedded/bin/rubocop --version"
    [ "$status" -eq 0 ]
}

@test "ChefSpec is installed." {
    run su - admin -c "/opt/chef/embedded/bin/rspec --version"
    [ "$status" -eq 0 ]
}

@test "Knife is installed." {
    run su - admin -c "/opt/chef/bin/knife --version"
    [ "$status" -eq 0 ]
}
