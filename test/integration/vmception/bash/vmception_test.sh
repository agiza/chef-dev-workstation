#!/bin/bash
# This script should be run via the busser-bash plugin for test kitchen.
# It recursively builds self-testing workstations inside nested docker containers.

# First clean up from any previous test runs
rm -rf chef-dev-workstation

# Next we want to clone the chef-dev-workstation repo, install cookbook dependencies, then run our test suite."
su - kitchen -c "git clone https://github.com/scarolan/chef-dev-workstation; cd ~/chef-dev-workstation; berks install; strainer test"

# Finally, spin up another instance inside here and test it too!
su - kitchen -c "cd ~/chef-dev-workstation; cp .kitchen.dind.yml .kitchen.yml; kitchen test dind-vmception"
