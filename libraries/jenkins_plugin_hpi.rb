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
    class JenkinsPluginHpi < Chef::Provider
      include Poise(inversion: :jenkins_plugin)
      provides(:hpi)
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
      def self.default_inversion_options(_node, _resource)
        super.merge(prefix: '/var/local/lib/jenkins/plugins',
          plugin_url: "https://mirrors.jenkins-ci.org/plugins/%{name}/%{version}/%{name}.hpi")
      end

      def action_create
        notifying_block do
          directory ::File.join(options[:prefix], new_resource.plugin_name) do
            recursive true
            mode '0755'
          end

          url = options[:plugin_url] % {name: new_resource.plugin_name, version: new_resource.version}
          remote_file ::File.join(options[:prefix], "#{new_resource.plugin_name}.hpi") do
            source url
            mode '0644'
            backup false
          end

          jenkins_command "#{new_resource.plugin_name}@#{new_resource.version}" do
            command ['install-plugin',
                     Shellwords.escape(new_resource.plugin_name),
                     '-name',
                     new_resource.plugin_name]
            notifies :reload, new_resource.parent, :delayed
          end
        end
      end

      def action_remove
        notifying_block do
          directory ::File.join(options[:prefix], new_resource.plugin_name) do
            recursive true
            action :delete
          end

          file ::File.join(options[:prefix], "#{new_resource.plugin_name}.hpi") do
            backup false
            action :delete
            notifies :reload, new_resource.parent, :delayed
          end
        end
      end
    end
  end
end
