#
# Cookbook: jenkins-cluster
# License: Apache 2.0
#
# Copyright 2010, VMware, Inc.
# Copyright 2013, Youscribe.
# Copyright 2012-2015, Chef Software, Inc.
# Copyright 2014-2016, Bloomberg Finance L.P.
#
include_recipe 'jenkins-cluster::default'
fail unless linux?

node.default['haproxy']['incoming_port'] = 80
node.default['haproxy']['members'] = [
  {'hostname' => 'localhost', 'ipaddress' => '127.0.0.1', 'port' => 8080}
]
include_recipe 'haproxy::default'

install = jenkins_installation node['jenkins']['service_name']

firewall_rule 'http' do
  port 80
  protocol :tcp
  position 1
  command :allow
end

directory File.join(node['jenkins']['service_home'], 'plugins') do
  owner node['jenkins']['service_user']
  group node['jenkins']['service_group']
  mode '0755'
end

log_file = File.join(node['jenkins']['service_home'], "#{node['jenkins']['service_name']}.log")
node.default['logrotate']['global'][log_file] = {
  'missingok' => true,
  'daily' => true,
  'copytruncate' => true,
  'compress' => true,
  'notifempty' => true,
  'create' => ['0644', node['jenkins']['service_user'], node['jenkins']['service_group']].join(' ')
}
include_recipe 'logrotate::global'

template 'jenkins - defaults file' do
  path '/etc/sysconfig/jenkins' if rhel?
  path '/etc/default/jenkins' if debian?
  source 'jenkins-config.sh.erb'
  variables(
    directory: File.join(node['jenkins']['service_home'], 'workspace'),
    service_user: node['jenkins']['service_user'],
    service_group: node['jenkins']['service_group'],
    webroot: node['jenkins']['service_home'],
    log_file: log_file
  )
end

jenkins_service node['jenkins']['service_name'] do
  warfile install.jenkins_warfile
  directory node['jenkins']['service_home']
  user node['jenkins']['service_user']
end
