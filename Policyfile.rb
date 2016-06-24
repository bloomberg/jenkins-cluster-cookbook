name 'default'
default_source :community
cookbook 'jenkins-cluster', path: '.'
cookbook 'ubuntu'
cookbook 'redhat'
cookbook 'windows'
run_list 'jenkins-cluster::default'
named_run_list :redhat, 'redhat::default', run_list
named_run_list :ubuntu, 'ubuntu::default', run_list
named_run_list :windows, 'windows::default', run_list
