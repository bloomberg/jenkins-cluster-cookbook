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
    class JenkinsInstallationPackage < Chef::Provider
      include Poise(inversion: :jenkins_installation)
      provides(:package)
      inversion_attribute('jenkins')

      # @param [Chef::Node] _node
      # @param [Chef::Resource] _resource
      # @return [TrueClass, FalseClass]
      # @api private
      def self.provides_auto?(_node, _resource)
        true
      end

      # Set the default inversion options.
      # @param [Chef::Node] node
      # @param [Chef::Resource] _resource
      # @return [Hash]
      # @api private
      def self.default_inversion_options(node, _resource)
        super.merge(package_name: 'jenkins', version: '2.10.1-1')
      end

      def action_create
        notifying_block do
          package_version = options[:version]
          package_source = options[:source]
          package options[:package_name] do
            version package_version if package_version
            source package_source if package_source
          end
        end
      end

      def action_remove
        notifying_block do
          package_version = options[:version]
          package options[:package_name] do
            version package_version if package_version
          end
        end
      end

      # @return [String]
      def jenkins_warfile
        options.fetch(:program, '/usr/lib/jenkins/jenkins.war')
      end
    end
  end
end
