# encoding: utf-8
# copyright: 2019, Graham Land

title 'Verify Base Application Binaries'

# control => test
control 'audit_installation_prerequisites' do
  impact 1.0
  title 'os and packages'
  desc 'verify os type and base os packages'

  describe os.family do
    it {should eq 'debian'}
  end

  describe package('wget') do
    it {should be_installed}
  end

  describe package('unzip') do
    it {should be_installed}
  end

  describe package('git') do
    it {should be_installed}
  end

  describe package('redis-server') do
    it {should be_installed}
  end

  describe package('nginx') do
    it {should be_installed}
  end

  describe package('lynx') do
    it {should be_installed}
  end

  describe package('jq') do
    it {should be_installed}
  end

  describe package('curl') do
    it {should be_installed}
  end

  describe package('net-tools') do
    it {should be_installed}
  end

end

control 'consul-binary-exists-1.0' do         
  impact 1.0                      
  title 'consul binary exists'
  desc 'verify that the consul binary is installed'
  describe file('/usr/local/bin/consul') do 
    it { should exist }
  end
end

control 'consul-binary-version-1.0' do                      
  impact 1.0                                
  title 'consul binary version check'
  desc 'verify that the consul binary is the correct version'
  describe command('consul version') do
   its('stdout') { should match /Consul v1.6.0-beta1/ }
  end
end

control 'consul-template-binary-exists-1.0' do         
  impact 1.0                      
  title 'consul-template binary exists'
  desc 'verify that the consul-template binary is installed'
  describe file('/usr/local/bin/consul-template') do 
    it { should exist }
  end
end

control 'consul-template-binary-version-1.0' do                      
  impact 1.0                                
  title 'consul-template binary version check'
  desc 'verify that the consul-template binary is the correct version'
  describe command('consul-template -version') do
   its('stderr') { should match /v0.20.0/ }
  end
end

control 'envconsul-binary-exists-1.0' do         
  impact 1.0                      
  title 'envconsul binary exists'
  desc 'verify that the envconsul binary is installed'
  describe file('/usr/local/bin/envconsul') do 
    it { should exist }
  end
end

control 'envconsul-binary-version-1.0' do                      
  impact 1.0                                
  title 'envconsul binary version check'
  desc 'verify that the envconsul binary is the correct version'
  describe command('envconsul -version') do
   its('stderr') { should match /v0.8.0/ }
  end
end

control 'vault-binary-exists-1.0' do         
  impact 1.0                      
  title 'vault binary exists'
  desc 'verify that the vault binary is installed'
  describe file('/usr/local/bin/vault') do 
    it { should exist }
  end
end

control 'vault-binary-version-1.0' do                      
  impact 1.0                                
  title 'vault binary version check'
  desc 'verify that the vault binary is the correct version'
  describe command('vault version') do
   its('stdout') { should match /v1.2.0-beta2/ }
  end
end

control 'nomad-binary-exists-1.0' do         
  impact 1.0                      
  title 'nomad binary exists'
  desc 'verify that the nomad binary is installed'
  describe file('/usr/local/bin/nomad') do 
    it { should exist }
  end
end

control 'nomad-binary-version-1.0' do                      
  impact 1.0                                
  title 'nomad binary version check'
  desc 'verify that the nomad binary is the correct version'
  describe command('nomad version') do
   its('stdout') { should match /v0.10.0-connect1/ }
  end
end

control 'terraform-binary-exists-1.0' do         
  impact 1.0                      
  title 'terraform binary exists'
  desc 'verify that the terraform binary is installed'
  describe file('/usr/local/bin/terraform') do 
    it { should exist }
  end
end

control 'terraform-binary-version-1.0' do                      
  impact 1.0                                
  title 'terraform binary version check'
  desc 'verify that the terraform binary is the correct version'
  describe command('terraform version') do
   its('stdout') { should match /v0.12.4/ }
  end
end
