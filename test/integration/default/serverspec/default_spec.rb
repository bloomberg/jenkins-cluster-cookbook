require 'serverspec'
set :backend, :exec

unless os[:family] == 'windows'
  describe group('butler') do
    it { should exist }
  end

  describe user('butler') do
    it { should exist }
    its(:groups) { should include 'butler' }
    its(:home) { should eq '/home/butler' }
  end

  %w{git jenkins}.each do |name|
    describe package(name) do
      it { should be_installed }
    end
  end

  describe file('/home/butler/workspace') do
    it { should exist }
    it { should be_directory }
    its(:owner) { should eq 'butler' }
    its(:group) { should eq 'butler' }
    its(:mode) { should eq 0755 }
  end
end
