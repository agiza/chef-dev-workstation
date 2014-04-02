# encoding: UTF-8
# Cookbook Name:: chef-dev-workstation
# Recipe:: dev_kernel
#

remote_file "#{Chef::Config[:file_cache_path]}/elrepo-release-6-6.el6.elrepo.noarch.rpm" do
  source "http://www.elrepo.org/elrepo-release-6-6.el6.elrepo.noarch.rpm"
end

yum_package "elrepo-release" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/elrepo-release-6-6.el6.elrepo.noarch.rpm"
end

yum_package "kernel-ml" do
  action :install
  options '--enablerepo=elrepo-kernel'
end

# This is is a bit janky and will fail if the kernel you want is not
# first on the list in grub.conf.  It works well enough for our needs.
execute "sed -i 's/^default=1/default=0/' /boot/grub/grub.conf" do
  not_if "grep 'default=0' /boot/grub/grub.conf"
end

# Reboot the machine if necessary to activate new kernel.
execute "/sbin/shutdown -r 0" do
  not_if "uname -r | grep '^3\.'"
end
