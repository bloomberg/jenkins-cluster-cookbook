#
# Cookbook: jenkins-cluster
# License: Apache 2.0
#
# Copyright 2010, VMware, Inc.
# Copyright 2013, Youscribe.
# Copyright 2012-2015, Chef Software, Inc.
# Copyright 2014-2016, Bloomberg Finance L.P.
#
fail if windows?
include_recipe 'jenkins-cluster::default'

firewall_rule 'redirect http to jenkins' do
  port 80
  redirect_port 8080
  action :redirect
end

directory File.join(node['jenkins']['service_home'], '.jenkins', 'war') do
  recursive true
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
    directory: File.join(node['jenkins']['service_home'], 'build'),
    service_user: node['jenkins']['service_user'],
    service_group: node['jenkins']['service_group'],
    webroot: File.join(node['jenkins']['service_home'], '.jenkins', 'war'),
    log_file: log_file
  )
end

service node['jenkins']['service_name'] do
  supports reload: true, restart: true
  action [:enable, :start]
end
