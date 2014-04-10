require 'spec_helper'

dotfiles = %w(.bash_profile .rubocop.yml .nanorc .vimrc)

dotfiles.each do |f|
  describe file("/home/vagrant/#{f}") do
    it { should be_file }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
    it { should be_mode 644 }
  end
end

describe file('/home/vagrant/.vim') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'vagrant' }
  it { should be_grouped_into 'vagrant' }
end
