name 'master'
default_source :community
run_list 'jenkins-cluster::master'
cookbook 'jenkins-cluster', path: '../../../'
