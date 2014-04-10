require 'spec_helper'

describe command('docker --version') do
  it { should return_exit_status 0 }
end

describe command("sudo service docker restart && sleep 10") do
  it { should return_exit_status 0 }
end

describe command("sudo docker run -t ubuntu grep Ubuntu /etc/lsb-release") do
  it { should return_exit_status 0 }
  it { should return_stdout(/Ubuntu/) }
end

describe command("sudo docker run -t centos grep CentOS /etc/redhat-release") do
  it { should return_exit_status 0 }
  it { should return_stdout(/CentOS/) }
end
