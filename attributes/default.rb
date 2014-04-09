# encoding: UTF-8
# Cookbook Name:: linux-chef-workstation
# Default attributes file
#

# The default password below is simply 'password'.  You can generate a new one like this:
# openssl passwd -1 'mynewpassword'

default['admin']['username'] = 'admin'
default['admin']['password'] = '$1$2COvX4FL$mTFCyb8YRGTOtLMTcEkeG1'
default['admin']['grantsudo'] = true

# Ruby Gems that you want to have on your workstation.
default['admin']['testgems'] = %w(berkshelf foodcritic test-kitchen kitchen-vagrant kitchen-docker chefspec strainer rubocop ruby-wmi knife-essentials knife-windows knife-spork knife-ec2 knife-vsphere knife-flip serverspec)

# Specify package installation settings here.  Add more packages for your platform as you wish.
case node['platform']
when 'centos', 'redhat', 'scientific', 'oracle', 'amazon'
  default['epel_yum_mirror_url'] = 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  default['epel_gpg_key_url'] = 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  default['package_list'] = %w(git libxml2-devel libxslt-devel nano emacs vim-enhanced curl docker-io)
when 'debian', 'ubuntu'
  default['package_list'] = %w(git libxml2-dev libxslt-dev nano emacs vim curl build-essential lxc)
end
