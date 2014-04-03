#!/bin/bash

# First clean up from any previous test runs
rm -rf chef-dev-workstation

# Next we want to clone the chef-dev-workstation repo, install cookbook dependencies, then run our test suite."
su - kitchen -c "git clone https://github.com/scarolan/chef-dev-workstation; cd ~/chef-dev-workstation; berks install; strainer test"

# Finally, spin up another instance inside here and test it too!
su - kitchen -c "cd ~/chef-dev-workstation; cp .kitchen.docker.yml .kitchen.yml; kitchen test docker-dind"
