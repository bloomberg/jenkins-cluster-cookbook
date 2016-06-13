#
# Cookbook: jenkins-cluster
# License: Apache 2.0
#
# Copyright 2010, VMware, Inc.
# Copyright 2013, Youscribe.
# Copyright 2012-2015, Chef Software, Inc.
# Copyright 2014-2016, Bloomberg Finance L.P.
#
include_recipe 'chef-sugar::default', 'chef-vault::default'

include_recipe 'yum-jenkins::default' if rhel?
if debian?
  node.default['apt']['compile_time_update'] = true
  include_recipe 'apt-jenkins::default'
end

include_recipe 'build-essential::default'
include_recipe 'java-service::default'
include_recipe 'git::default'
include_recipe 'selinux::disabled' if linux?

node.default['firewall']['allow_winrm'] = true if windows?
node.default['firewall']['allow_ssh'] = true unless windows?
include_recipe 'firewall::default'

node.default['poise-python']['install_python2'] = true
node.default['poise-python']['install_pypy'] = true
include_recipe 'poise-python::default'
python_package 's3cmd'

node.default['poise-ruby']['provider'] = 'ruby_build'
node.default['poise-ruby']['install_ruby'] = true
node.default['poise-ruby']['install_chef_ruby'] = false
include_recipe 'poise-ruby::default'
ruby_gem 'bundler'
ruby_gem 'nokogiri'
ruby_gem 'rake'

node.default['poise-javascript']['install_nodejs'] = true
include_recipe 'poise-javascript::default'
node_package 'bower'
node_package 'grunt'

group node['jenkins']['service_group']
user node['jenkins']['service_user'] do
  home node['jenkins']['service_home']
  group node['jenkins']['service_group']
  manage_home true
end

directory node['jenkins']['service_home'] do
  recursive true
  owner node['jenkins']['service_user']
  group node['jenkins']['service_group']
end

user_ulimit node['jenkins']['service_user'] do
  filehandle_limit 8192
  not_if { windows? }
end

directory File.join(node['jenkins']['service_home'], 'workspace') do
  owner node['jenkins']['service_user']
  group node['jenkins']['service_group']
  mode '0755'
end

install = jenkins_installation node['jenkins']['service_name'] do
  version node['jenkins']['version']
end
