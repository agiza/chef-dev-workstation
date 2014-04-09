require 'spec_helper'

describe user('vagrant') do
  it { should exist }
  it { should belong_to_group 'vagrant' }
  it { should have_home_directory '/home/vagrant' }
  it { should have_login_shell '/bin/bash' }
end

describe command('grep vagrant /etc/sudoers') do
  it { should return_exit_status 0 }
end
