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
      def self.default_inversion_attributes(node, _resource)
        super.merge(
          package: default_package_name(node),
          version: default_package_version(node)
        )
      end

      def action_create
        notifying_block do
          package_version = options[:version]
          package_source = options[:source]
          package options[:package] do
            notifies :delete, init_file, :immediately
            version package_version if package_version
            source package_source if package_source
          end
        end
      end

      def action_remove
        notifying_block do
          package_version = options[:version]
          package options[:package] do
            version package_version if package_version
          end
        end
      end

      # @return [String]
      def jenkins_jarfile
        options.fetch(:program, '')
      end

      # @param [Chef::Node] node
      # @return [String]
      def self.default_package_name(node)
        case node.platform_family
        when 'rhel' then 'jenkins'
        when 'debian' then 'jenkins'
        end
      end

      # @param [Chef::Node] node
      # @return [String]
      # @api private
      def self.default_package_version(node)
        case node.platform
        when 'redhat', 'centos'
          case node.platform_version.to_i
          when 5 then '2.4.10-1.el5'
          when 6 then '2.4.10-1.el6'
          when 7 then '2.8.19-2.el7'
          end
        when 'ubuntu'
          case node.platform_version.to_i
          when 12 then '2.2.12-1'
          when 14 then '2:2.8.4-2'
          when 16 then '2:3.0.6-1'
          end
        when 'freebsd'
          case node.platform_version.to_i
          when 10 then '3.0.7'
          end
        end
      end
    end
  end
end
