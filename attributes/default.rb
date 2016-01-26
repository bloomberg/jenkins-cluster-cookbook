#
# Cookbook: jenkins-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
default['jenkins']['service_name'] = 'jenkins'
default['jenkins']['service_user'] = 'butler'
default['jenkins']['service_group'] = 'butler'
default['jenkins']['service_home'] = '/home/butler'
