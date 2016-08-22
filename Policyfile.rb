name 'default'
default_source :community
cookbook 'jenkins-cluster', path: '.'
run_list 'jenkins-cluster::default'
named_run_list :centos, 'yum-epel::default', run_list
named_run_list :debian, 'apt::default', run_list
named_run_list :windows, 'windows::default', run_list
