require 'spec_helper'

describe user('chef') do
  it { should exist }
  it { should belong_to_group 'chef' }
  it { should have_home_directory '/home/chef' }
  it { should have_login_shell '/bin/bash' }
end

describe command('grep chef /etc/sudoers') do
  it { should return_exit_status 0 }
end
