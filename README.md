# jenkins-cluster-cookbook
[![Build Status](https://img.shields.io/travis/bloomberg/jenkins-cluster-cookbook.svg)](https://travis-ci.org/bloomberg/jenkins-cluster-cookbook)
[![Code Quality](https://img.shields.io/codeclimate/github/bloomberg/jenkins-cluster-cookbook.svg)](https://codeclimate.com/github/bloomberg/jenkins-cluster-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/jenkins-cluster.svg)](https://supermarket.chef.io/cookbooks/jenkins-cluster)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

## Basic Usage
The [default recipe](recipes/default.rb) configures the node with a
variety of software that would be needed on a Jenkins worker node. A
comprehensive list of software is at the bottom of this section.

The [master recipe](recipes/master.rb) includes the default recipe,
since it too will be treated as a worker node, and also configures log
rotation, firewall, and most importantly plugins for the Jenkins
master node.

The software installed by the default recipe:

- Build tools (GCC, Make, CMake, etc)
- Chef Development Kit
- SCM tools (Git, Subversion, Mercurial)
- Docker
- Terraform
- Runtimes and support tools (Java, Ruby, Python, Node)
