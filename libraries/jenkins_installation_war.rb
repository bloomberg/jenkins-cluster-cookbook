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
    class JenkinsInstallationWar < Chef::Provider
      include Poise(inversion: :jenkins_installation)
      provides(:war)
      inversion_attribute('jenkins')

      # @param [Chef::Node] _node
      # @param [Resource::JenkinsInstallation] _resource
      # @return [TrueClass, FalseClass]
      # @api private
      def self.provides_auto?(_node, _resource)
        true
      end

      # Set the default inversion options.
      # @param [Chef::Node] node
      # @param [Resource::JenkinsInstallation] _resource
      # @return [Hash]
      # @api private
      def self.default_inversion_options(_node, resource)
        super.merge(version: resource.version,
          warfile_url: 'http://mirrors.jenkins-ci.org/war',
          warfile_checksum: default_warfile_checksum(resource.version))
      end

      def action_create
        notifying_block do
          directory jenkins_prefix do
            recursive true
            mode '0755'
          end

          remote_file jenkins_warfile do
            source options[:warfile_url]
            checksum options[:warfile_checksum]
          end
        end
      end

      def action_remove
        notifying_block do
          directory jenkins_prefix do
            recursive true
            action :delete
          end
        end
      end

      # @return [String]
      def jenkins_prefix
        options.fetch(:prefix, ::File.join('/usr/local/lib/jenkins', options[:version]))
      end

      # @return [String]
      def jenkins_warfile
        options.fetch(:program, ::File.join(jenkins_prefix, 'jenkins.war'))
      end

      def self.default_warfile_checksum(version)
        case version
        when '1.651' then '9fe9382e1443bb27de55dce15850bc0a0890d8aa837c3839fcf4407e1f7e4993'
        when '1.658' then '108a496a01361e598cacbcdc8fcf4070e4dab215fb76f759dd75384af7104a3c'
        when '2.7' then '2fead2f4aa0a8ba7d76b43fdb4ff5350bdd686bc21371f600861b7a85c51c605'
        when '2.8' then '586b3ba1d1fcfd54a719fd34178b486a963eda91d7c56c98d7cb8ad82c6c050f'
        when '2.9' then 'a2fa588244f82ee82ba8951a9611629109bd35a63ce48d15dae7c925c2da0a51'
        when '2.10' then '47a64a0b32b1c3e1496e4663b9b3d94f4faa851e276a47b881ce8507712ea081'
        end
      end
    end
  end
end
