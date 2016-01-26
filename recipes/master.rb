#
# Cookbook: jenkins-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
include_recipe 'jenkins-cluster::default'

firewall_rule 'redirect http to jenkins' do
  port 80
  redirect_port 8080
  action :redirect
  not_if { windows? }
end
