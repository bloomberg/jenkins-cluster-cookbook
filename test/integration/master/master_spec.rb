describe port(8080) do
  it { should be_listening }
  its(:processes) { should include 'jenkins' }
end

describe service('jenkins') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
