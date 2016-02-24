name 'default'
default_source :community
run_list 'jenkins-cluster::default'
cookbook 'jenkins-cluster', path: '../../../'
