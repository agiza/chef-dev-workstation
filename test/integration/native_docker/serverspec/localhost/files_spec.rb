require 'spec_helper'

dotfiles = %w(.bash_profile .rubocop.yml .nanorc .vimrc)

dotfiles.each do |f|
  describe file("/home/chef/#{f}") do
    it { should be_file }
    it { should be_owned_by 'chef' }
    it { should be_grouped_into 'chef' }
    it { should be_mode 644 }
  end
end

describe file('/home/chef/.vim') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'chef' }
  it { should be_grouped_into 'chef' }
end
