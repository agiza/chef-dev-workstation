#!/bin/bash

# First clean up from any previous test runs
rm -rf chef-dev-workstation

# Next we want to clone the chef-dev-workstation repo, install cookbook dependencies, then run our test suite."
su - vagrant -c "git clone https://github.com/scarolan/chef-dev-workstation; cd ~/chef-dev-workstation; berks install; strainer test"
