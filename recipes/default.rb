#
# Cookbook: jenkins-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
include_recipe 'chef-sugar::default'
include_recipe 'chef-vault::default'
include_recipe 'java-service::default'
include_recipe 'git::default'
include_recipe 'selinux::disabled'

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

include_recipe 'yum-jenkins::default' if rhel?
include_recipe 'apt-jenkins::default' if debian?
