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
  module Provider
    # @action create
    # @action remove
    # @since 1.0
    class JenkinsInstallationJar < Chef::Provider
      include Poise(inversion: :jenkins_installation)
      provides(:jar)

      # Set the default inversion options.
      # @param [Chef::Node] node
      # @param [Chef::Resource] _resource
      # @return [Hash]
      # @api private
      def self.default_inversion_attributes(node, _resource)
        super.merge(
        )
      end

      def action_create
        notifying_block do
        end
      end

      def action_remove
        notifying_block do
        end
      end

      # @return [String]
      def jenkins_jarfile
        options.fetch(:program, '')
      end
    end
  end
end
