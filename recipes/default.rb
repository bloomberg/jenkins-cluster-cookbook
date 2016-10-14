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
require 'chef/sugar/core_extensions'

include_recipe 'build-essential::default'
include_recipe 'cron::default'
include_recipe 'cmake::default'
include_recipe 'git::default'
include_recipe 'mercurial::default'
include_recipe 'subversion::client'
include_recipe 'java-service::default'
include_recipe 'terraform::default'
include_recipe 'packer::default'
include_recipe 'selinux::disabled' if linux?

node.default['firewall']['allow_winrm'] = true if windows?
node.default['firewall']['allow_ssh'] = true unless windows?
include_recipe 'firewall::default'

group node['jenkins']['service_group']
user node['jenkins']['service_user'] do
  home node['jenkins']['service_home']
  group node['jenkins']['service_group']
  manage_home true
end

directory node['jenkins']['service_home'] do
  owner node['jenkins']['service_user']
  group node['jenkins']['service_group']
  mode '0755'
end

directory File.join(node['jenkins']['service_home'], 'workspace') do
  owner node['jenkins']['service_user']
  group node['jenkins']['service_group']
  mode '0755'
end

user_ulimit node['jenkins']['service_user'] do
  filehandle_limit 8192
  not_if { windows? }
end

node.override['poise-python']['provider'] = 'system'
node.override['poise-python']['install_python2'] = true
include_recipe 'poise-python::default'
python_package 's3cmd'

node.override['chef_dk']['gems'] = %w{kitchen-dokken kitchen-openstack}
node.override['chef_dk']['global_shell_init'] = true
include_recipe 'chef-dk::default'

docker_service 'default' do
  action [:create, :start]
  group 'docker'
  bip '192.18.0.1/15'
  ipv6 false
end
