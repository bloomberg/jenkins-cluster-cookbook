#
# Cookbook: jenkins-cluster
# License: Apache 2.0
#
# Copyright 2010, VMware, Inc.
# Copyright 2013, Youscribe.
# Copyright 2012-2015, Chef Software, Inc.
# Copyright 2014-2016, Bloomberg Finance L.P.
#
require 'poise'

module JenkinsClusterCookbook
  module Resource
    # A `jenkins_plugin` resource which manages the installation of
    # the plugins of a Jenkins instance.
    # @provides create
    # @provides remove
    # @since 1.0
    class JenkinsPlugin < Chef::Resource
      include Poise(inversion: true, parent: :jenkins_service)
      provides(:jenkins_plugin)
      default_action(:create)
      actions(:create, :remove)

      # @!attribute plugin_name
      # The name of the Jenkins plugin to install.
      # @return [String]
      property(:plugin_name, kind_of: String, identity: true)
      # @!attribute version
      # The version of the Jenkins plugin to install.
      # @return [String]
      property(:version, kind_of: String, default: 'latest')
    end
  end
end
