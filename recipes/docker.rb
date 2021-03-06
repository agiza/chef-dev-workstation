# encoding: UTF-8
# Cookbook Name:: chef-dev-workstation
# Recipe:: docker
#

# Warn the user that they need to reboot if kernel was updated
log 'reboot_message' do
  message <<-END.gsub(/^ {4}/, '')

    *********************************************************************
    *                    WARNING: Reboot Required                       *
    *            The kernel on this instance was updated.               *
    *********************************************************************
  END
  action :nothing
end

case node['platform']
when 'centos', 'redhat', 'scientific', 'amazon', 'oracle'
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
    # notifies :run, "execute[reboot]"
    notifies :write, 'log[reboot_message]'
  end

  # Disable the abomination that is SELinux
  execute "sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config" do
    not_if "grep '^SELINUX=disabled$' /etc/selinux/config"
    # notifies :run, "execute[reboot]"
    notifies :write, 'log[reboot_message]'
  end

  # Enable and start docker
  service 'docker' do
    action [ :enable, :start ]
  end

  # Reboot the machine to activate new kernel and disable SElinux permanently.
  execute "reboot" do
    action :nothing
    command "/sbin/shutdown -r 0"
  end
when 'ubuntu', 'debian'
  # TO DO:  Make this idempotent
  # Install the docker apt repo key
  execute 'apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9'

  # Update our package cache
  execute 'apt-get update'

  # Turn off apparmor, remove it entirely
  execute '/etc/init.d/apparmor stop; update-rc.d -f apparmor remove; apt-get -y --purge remove apparmor apparmor-utils libapparmor-perl libapparmor1'

  # Create the docker apt repo and update the cache during compile phase.
  dockerrepo = template '/etc/apt/sources.list.d/docker.list' do
    source 'docker.list.erb'
    owner 'root'
    group 'root'
    mode '0644'
  end

  aptupdate = execute 'apt-get update' do
    action :nothing
  end

  dockerrepo.run_action(:create)
  aptupdate.run_action(:run)

  # Now we should be able to install these without issues.
  package 'lxc' do
    action :install
  end

  package 'lxc-docker' do
    action :install
  end

  # Install a newer kernel and reboot if on 12.x versions
  package 'linux-image-generic-lts-raring' do
    action :install
    not_if { node['platform_version'] == '13.10' }
    # notifies :run, "execute[reboot]"
    notifies :write, "log[reboot_message]"
  end

  # Start up docker
  service 'docker' do
    action [ :enable, :start ]
  end

  # Reboot the machine to activate new kernel
  execute "reboot" do
    action :nothing
    command "/sbin/shutdown -r 0"
  end

end
