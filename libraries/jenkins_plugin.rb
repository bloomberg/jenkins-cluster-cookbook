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
      include Poise
      provides(:jenkins_plugin)
      default_action(:create)
      actions(:create, :remove)

      property(:owner, kind_of: String, default: 'butler')
      property(:group, kind_of: String, default: 'butler')

      property(:plugin_name, kind_of: String, name_property: true)
      property(:version, kind_of: String, default: 'latest')
      property(:plugin_directory, kind_of: String, default: '/home/butler/plugins')
      property(:source, kind_of: String)
      property(:options, option_collector: true, default: {})

      def data_directory
        ::File.join(plugin_directory, name)
      end

      def filepath
        ::File.join(plugin_directory, "#{plugin_name}.jpi")
      end
    end
  end

  module Provider
    # @provides create
    # @provides remove
    # @since 1.0
    class JenkinsPlugin < Chef::Provider
      include Poise
      provides(:jenkins_plugin)

      def load_current_resource
      end

      def action_create
        notifying_block do
          directory new_resource.data_directory do
            recursive true
            owner new_resource.owner
            group new_resource.group
            mode '0755'
          end

          if new_resource.remote_file
            install_from_url
          else
            install_from_update_center
          end
        end
      end

      def action_remove
        notifying_block do
          directory current_resource.data_directory do
            recursive true
            action :delete
          end

          file current_resource.filepath do
            backup false
            action :delete
          end
        end
      end

      private
      def install_from_url(name, version, url, checksum)
        remote_file new_resource.filepath do
          owner new_resource.owner
          group new_resource.group
          mode '0644'
          source new_resource.remote_url
          checksum new_resource.remote_checksum
          backup false
        end

        jenkins_command "#{new_resource.plugin_name}@#{new_resource.version}" do
          command ['install-plugin', Shellwords.escape(plugin_name), '-name', plugin_name]
        end
      end

      def install_from_update_center
      end
    end
  end
end
