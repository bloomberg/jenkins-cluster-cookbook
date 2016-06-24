require 'spec_helper'
require_relative '../../../libraries/jenkins_installation.rb'
require_relative '../../../libraries/jenkins_installation_package.rb'

describe JenkinsClusterCookbook::Provider::JenkinsInstallationPackage do
  step_into(:jenkins_installation)
  let(:chefspec_options) { {platform: 'redhat', version: '7.2'} }
  let(:default_attributes) { {jenkins: {provider: 'package', version: '2.10-1.1'}} }

  context "with node['platform'] = 'redhat' AND node['platform_version'] = '7.2'" do
    it { is_expected.to install_package('jenkins').with(package_name: 'jenkins', version: '2.10-1.1') }
  end

  context "with node['platform'] = 'redhat' AND node['platform_version'] = '6.7'" do
    let(:chefspec_options) { {platform: 'redhat', version: '6.7'} }

    it { is_expected.to install_package('jenkins').with(package_name: 'jenkins', version: '2.10-1.1') }
  end

  context "with node['platform'] = 'redhat' AND node['platform_version'] = '5.11'" do
    let(:chefspec_options) { {platform: 'redhat', version: '5.11'} }

    it { is_expected.to install_package('jenkins').with(package_name: 'jenkins', version: '2.10-1.1') }
  end

  context "with node['platform'] = 'ubuntu' AND node['platform_version'] = '16.04']" do
    let(:chefspec_options) { {platform: 'ubuntu', version: '16.04'} }

    it { is_expected.to install_package('jenkins').with(package_name: 'jenkins', version: '2.10-1.1') }
  end

  context "with node['platform'] = 'ubuntu' AND node['platform_version'] = '14.04']" do
    let(:chefspec_options) { {platform: 'ubuntu', version: '14.04'} }

    it { is_expected.to install_package('jenkins').with(package_name: 'jenkins', version: '2.10-1.1') }
  end

  context "with node['platform'] = 'ubuntu' AND node['platform_version'] = '12.04']" do
    let(:chefspec_options) { {platform: 'ubuntu', version: '12.04'} }

    it { is_expected.to install_package('jenkins').with(package_name: 'jenkins', version: '2.10-1.1') }
  end
end
