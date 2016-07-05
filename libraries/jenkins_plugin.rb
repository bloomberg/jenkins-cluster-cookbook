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
      include Poise(fused: true, parent: :jenkins_service)
      provides(:jenkins_plugin)

      # @!attribute plugin_name
      # The name of the Jenkins plugin to install.
      # @return [String]
      property(:plugin_name, kind_of: String, name_property: true)
      # @!attribute version
      # The version of the Jenkins plugin to install.
      # @return [String]
      property(:version, kind_of: String, default: 'latest')

      property(:plugin_prefix, kind_of: String, default: '/usr/local/lib/jenkins/plugins')
      property(:plugin_url, kind_of: String, default: "https://mirrors.jenkins-ci.org/plugins/%{name}/%{version}/%{name}.hpi")

      action(:create) do
        notifying_block do
          directory ::File.join(new_resource.plugin_prefix, new_resource.plugin_name) do
            recursive true
            mode '0755'
          end

          url = new_resource.plugin_url % {name: new_resource.plugin_name, version: new_resource.version}
          remote_file ::File.join(new_resource.plugin_prefix, "#{new_resource.plugin_name}.hpi") do
            source url
            mode '0644'
            backup false
          end

          jenkins_command "#{new_resource.plugin_name}@#{new_resource.version}" do
            command ['install-plugin',
                     Shellwords.escape(new_resource.plugin_name),
                     '-name',
                     new_resource.plugin_name]
            notifies :restart, new_resource.parent, :delayed
          end
        end
      end

      action(:remove) do
        notifying_block do
          directory ::File.join(new_resource.plugin_prefix, new_resource.plugin_name) do
            recursive true
            action :delete
          end

          file ::File.join(new_resource.plugin_prefix, "#{new_resource.plugin_name}.hpi") do
            backup false
            action :delete
            notifies :restart, new_resource.parent, :delayed
          end
        end
      end
    end
  end
end
