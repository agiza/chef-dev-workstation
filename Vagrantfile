# encoding: UTF-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

# NOTE: vagrant-berkshelf is deprecated.  Long live test kitchen.
# We recommend switching to test kitchen instead of using Vagrant
# directly.

# Seriously.  Go download test kitchen and learn to use it.

cookbook_name = File.basename(Dir.getwd)

Vagrant.configure('2') do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = 'linux-chef-workstation'

  # Every Vagrant virtual environment requires a box to build off of.
  # This is the official Chef CentOS 6.5 image
  config.vm.box = 'opscode-centos-6.5'

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = 'https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_centos-6.5_provisionerless.box'

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, ip: '172.16.100.10'

  # Set a boot timeout in case the maching hangs
  config.vm.boot_timeout = 120

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.

  # config.vm.network :public_network

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # Enable the chef omnibus plugin so we get the latest client
  config.omnibus.chef_version = :latest

  # An array of symbols representing groups of cookbooks described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbooks described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      # We force this user to be vagrant, because the setup.rb recipe overwrites sudoers
      # The Vagrant user needs sudo in order to function properly.
      'admin' => { 'username' => 'vagrant' }
    }

    chef.run_list = [
      "recipe[#{cookbook_name}::default]"
    ]

    # chef.log_level = 'debug'
  end
end
