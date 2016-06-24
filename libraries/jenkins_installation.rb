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
    # @provides jenkins_installation
    # @action create
    # @action remove
    # @since 1.0
    class JenkinsInstallation < Chef::Resource
      include Poise(inversion: true)
      provides(:jenkins_installation)
      actions(:create, :remove)
      default_action(:create)

      # @!attribute user
      # @return [String]
      property(:owner, kind_of: String, default: 'jenkins')
      # @!attribute group
      # @return [String]
      property(:group, kind_of: String, default: 'jenkins')
      # @!attribute version
      # The version of Jenkins to install.
      # @return [String]
      property(:version, kind_of: [NilClass, String], default: nil)

      # @return [String]
      def jenkins_jarfile
        @jarfile ||= provider_for_action(:jenkins_jarfile).jenkins_jarfile
      end
    end
  end
end
