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
    # @provides jenkins_installation_package
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
          warfile_url: "http://mirrors.jenkins-ci.org/war-stable/%{version}/jenkins.war",
          warfile_checksum: default_warfile_checksum(resource.version))
      end

      def action_create
        url = options[:warfile_url] % {version: options[:version]}
        notifying_block do
          directory jenkins_prefix do
            recursive true
            mode '0755'
          end

          remote_file jenkins_warfile do
            source url
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
        when '1.651.3' then '9fe9382e1443bb27de55dce15850bc0a0890d8aa837c3839fcf4407e1f7e4993'
        when '2.7.4' then '32e07928198e065965e598ab5a655e2d21be2407873ce2533d0edb58aa1a369a'
        when '2.19.3' then 'bad23e08ce084fdaaccfb7c76fccf435f62cda30c6095b4b3929fb02a9ab3a36'
        end
      end
    end
  end
end
