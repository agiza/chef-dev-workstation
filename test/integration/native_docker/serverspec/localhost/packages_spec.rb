require 'spec_helper'

rubygems = %w(kitchen berks foodcritic rubocop rspec)

describe command('gcc --version') do
  it { should return_exit_status 0 }
end

describe command('su - chef -c "/opt/chef/bin/knife --version"') do
  it { should return_exit_status 0 }
end

rubygems.each do |gem|
  describe command("su - chef -c \"/opt/chef/embedded/bin/#{gem} --version\"") do
    it { should return_exit_status 0 }
  end
end
