name 'jenkins-cluster'
maintainer 'John Bellone'
maintainer_email 'jbellone@bloomberg.net'
license 'Apache 2.0'
description 'Application cookbook which installs and configures Jenkins.'
long_description 'Application cookbook which installs and configures Jenkins.'
version '1.0.0'
source_url 'https://github.com/bloomberg/jenkins-cluster-cookbook'
issues_url 'https://github.com/bloomberg/jenkins-cluster-cookbook/issues'

supports 'ubuntu', '>= 12.04'
supports 'centos', '>= 5.8'
supports 'aix'
supports 'solaris'
supports 'windows'

depends 'apt-jenkins'
depends 'build-essential'
depends 'chef-vault'
depends 'chef-sugar'
depends 'firewall', '~> 2.0'
depends 'git'
depends 'java-service', '~> 2.2'
depends 'logrotate'
depends 'poise', '~> 2.2'
depends 'poise-service', '~> 1.0'
depends 'poise-javascript'
depends 'poise-python'
depends 'poise-ruby'
depends 'poise-ruby-build'
depends 'selinux'
depends 'ulimit'
depends 'yum-jenkins'
