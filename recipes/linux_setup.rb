# encoding: UTF-8
# Cookbook Name:: chef-dev-workstation
# Recipe:: linux_setup
#
adminuser = node['admin']['username']

##############################################################################
# First create an admin user
##############################################################################
group adminuser do
  gid '1001'
  not_if "getent group #{adminuser}"
end

user adminuser do
  comment 'Admin User'
  uid '1001'
  home "/home/#{adminuser}"
  shell '/bin/bash'
  group adminuser
  supports manage_home: true
  password node['admin']['password']
  not_if "getent passwd #{adminuser}"
end

##############################################################################
# Give the admin user sudo rights
# Uncomment if you want your user to have sudo with NOPASSWD
##############################################################################
execute 'grant_sudo' do
  command "echo '#{node['admin']['username']}  ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
  only_if do
    node['admin']['grantsudo'] && !File.readlines("/etc/sudoers").grep(/#{node['admin']['username']}/).any?
  end
end

##############################################################################
# More dots! Config files for the admin user
# Enables rubocop syntax checker in Vim, and Ruby highlighting in nano
##############################################################################
dotfiles = %w(bash_profile nanorc vimrc rubocop.yml)

dotfiles.each do |file|
  template "/home/#{adminuser}/.#{file}" do
    source "#{file}.erb"
    owner adminuser
    group adminuser
    mode '0644'
  end
end

##############################################################################
# Install platform-specific packages
##############################################################################
case node['platform']
when 'centos', 'redhat', 'scientific', 'amazon', 'oracle'
  # This is required to install git, and possibly other packages.
  yum_repository 'epel' do
    description 'Extra Packages for Enterprise Linux'
    mirrorlist node['epel_yum_mirror_url']
    gpgkey node['epel_gpg_key_url']
    action :create
  end

  # Yum resource doesn't support 'groupinstall', so we use execute instead.
  execute "yum -y groupinstall 'Development Tools'" do
    not_if "rpm -q gcc"
  end
when 'ubuntu', 'debian'
  # Update the apt cache!
  aptupdate = execute 'apt-get update' do
    action :nothing
  end
  aptupdate.run_action(:run)
end

# Take the default package_list for our platform and install packages
node['package_list'].each do |pack|
  package pack
end

##############################################################################
# Pimp my Vim
# The following section will give you the Vim pathogen plugin manager,
# the vim-sensible repo which sets up reasonable defaults for your vim config
# and the syntastic syntax checker.  Configure your .vimrc with the dotfile
# listed in the 'dotfiles' section above.
##############################################################################
dirs = %w(.vim .vim/bundle .vim/autoload)

dirs.each do |dir|
  directory "/home/#{adminuser}/#{dir}" do
    owner adminuser
    group adminuser
    mode '0755'
  end
end

# This was failing, so moved it to a template instead.
#remote_file "/home/#{adminuser}/.vim/autoload/pathogen.vim" do
#  source 'http://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim'
#  owner adminuser
#  group adminuser
#end

template "/home/#{adminuser}/.vim/autoload/pathogen.vim" do
  source 'pathogen.vim.erb'
  owner adminuser
  group adminuser
end

git "/home/#{adminuser}/.vim/bundle/vim-sensible" do
  repository 'git://github.com/tpope/vim-sensible.git'
  user adminuser
  group adminuser
end

git "/home/#{adminuser}/.vim/bundle/syntastic" do
  repository 'git://github.com/scrooloose/syntastic.git'
  user adminuser
  group adminuser
end

##############################################################################
# Gems everywhere!
# Here we install all the RubyGems that we want to have for our workstation
# environment. Add more if you like!
##############################################################################

node['admin']['testgems'].each do |gem|
  gem_package gem do
    source node['admin']['gemrepo']
  end
end
