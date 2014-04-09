require 'spec_helper'

describe command('su - vagrant -c "docker --version"') do
  it { should return_exit_status 0 }
end
