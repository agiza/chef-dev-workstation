# encoding: UTF-8
require 'spec_helper'

RSpec.configure do |config|
  config.platform = 'centos'
  config.version = '6.4'
end

describe 'chef-dev-workstation::docker' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  # ChefSpec doesn't run real commands, so we stub them here
  before do
    stub_command("grep 'default=0' /boot/grub/grub.conf").and_return(false)
    stub_command("grep '^SELINUX=disabled$' /etc/selinux/config").and_return(false)
  end

  it 'downloads the elrepo-release RPM' do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/elrepo-release-6-6.el6.elrepo.noarch.rpm").with(
      :source => 'http://www.elrepo.org/elrepo-release-6-6.el6.elrepo.noarch.rpm'
    )
  end

  it 'installs the new kernel' do
    expect(chef_run).to install_yum_package('kernel-ml')
  end

  it 'fixes up the grub configuration' do
    expect(chef_run).to run_execute('sed -i \'s/^default=1/default=0/\' /boot/grub/grub.conf')
  end

  it 'disables SELinux' do
    expect(chef_run).to run_execute('sed -i \'s/^SELINUX=.*/SELINUX=disabled/\' /etc/selinux/config')
  end

  it 'starts up the Docker service' do
    expect(chef_run).to start_service('docker')
  end

end
