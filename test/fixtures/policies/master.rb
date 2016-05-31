name 'default'
default_source :community
run_list 'jenkins-cluster::master'
cookbook 'jenkins-cluster', path: '../../../'
cookbook 'ubuntu'
cookbook 'redhat'
named_run_list :redhat, 'redhat::default', 'jenkins-cluster::master'
named_run_list :ubuntu, 'ubuntu::default', 'jenkins-cluster::master'
