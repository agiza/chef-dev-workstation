# encoding: UTF-8
require 'spec_helper'

RSpec.configure do |config|
  config.platform = 'centos'
  config.version = '6.4'
end

describe 'chef-dev-workstation::linux_setup' do
  let(:adminuser) { 'admin' }
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  before do
    stub_command("rpm -q gcc").and_return(true)
    File.stub_chain(:readlines, :grep, :any?).and_return(true)
  end

  # ChefSpec doesn't run real commands, so we stub them here
  before do
    stub_command("getent passwd #{adminuser}").and_return(false)
    stub_command("getent group #{adminuser}").and_return(false)
  end

  # Some basic unit tests
  it 'creates the adminuser group' do
    expect(chef_run).to create_group(adminuser)
  end

  it 'creates the adminuser user' do
    expect(chef_run).to create_user(adminuser)
  end

  it 'renders the admin user dotfiles' do
    %w(bash_profile nanorc vimrc rubocop.yml).each do |file|
      expect(chef_run).to render_file("/home/#{adminuser}/.#{file}")
    end
  end

  it 'creates the Vim directories' do
    %w(.vim .vim/bundle .vim/autoload).each do |dir|
      expect(chef_run).to create_directory("/home/#{adminuser}/#{dir}")
    end
  end

  it 'creates the pathogen configuration file' do
    expect(chef_run).to create_remote_file("/home/#{adminuser}/.vim/autoload/pathogen.vim")
  end

  it 'clones the vim-sensible git repository' do
    expect(chef_run).to sync_git("/home/#{adminuser}/.vim/bundle/vim-sensible")
  end

  it 'clones the syntastic git repository' do
    expect(chef_run).to sync_git("/home/#{adminuser}/.vim/bundle/syntastic")
  end

  it 'installs the required RPM packages' do
    %w(git libxml2-devel libxslt-devel nano emacs).each do |rpm|
      expect(chef_run).to install_package(rpm)
    end
  end

  it 'installs the required RubyGems' do
    gems = %w(berkshelf foodcritic test-kitchen kitchen-vagrant chefspec strainer rubocop ruby-wmi knife-essentials knife-windows knife-spork knife-ec2 knife-vsphere)
    gems.each do |gem|
      expect(chef_run).to install_gem_package(gem)
    end
  end

end
