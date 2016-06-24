require 'spec_helper'
require_relative '../../../libraries/jenkins_installation.rb'
require_relative '../../../libraries/jenkins_installation_jar.rb'

describe JenkinsClusterCookbook::Provider::JenkinsInstallationJar do
  step_into(:jenkins_installation)
  let(:default_attributes) { {jenkins: { provider: 'jar'}} }

  context "with node['platform'] = 'redhat' AND node['platform_version'] = '7.2'" do
    let(:chefspec_options) { {platform: 'redhat', version: '7.2'} }
  end

  context "with node['platform'] = 'redhat' AND node['platform_version'] = '6.7'" do
    let(:chefspec_options) { {platform: 'redhat', version: '6.7'} }
  end

  context "with node['platform'] = 'redhat' AND node['platform_version'] = '5.11'" do
    let(:chefspec_options) { {platform: 'redhat', version: '5.11'} }
  end

  context "with node['platform'] = 'ubuntu' AND node['platform_version'] = '16.04']" do
    let(:chefspec_options) { {platform: 'ubuntu', version: '16.04'} }
  end

  context "with node['platform'] = 'ubuntu' AND node['platform_version'] = '14.04']" do
    let(:chefspec_options) { {platform: 'ubuntu', version: '14.04'} }
  end

  context "with node['platform'] = 'ubuntu' AND node['platform_version'] = '12.04']" do
    let(:chefspec_options) { {platform: 'ubuntu', version: '12.04'} }
  end
end
