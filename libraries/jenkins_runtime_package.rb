#
# Cookbook: jenkins-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module JenkinsClusterCookbook
  module Provider
    # @since 1.0
    class JenkinsRuntimePackage < Chef::Provider
      include Poise
      provides(:jenkins_runtime)
      provides(:jenkins_runtime_package)

      def action_create
        notifying_block do
          package new_resource.package_name do
            version new_resource.package_version
            action :upgrade
          end
        end
      end

      def action_remove
        notifying_block do
          package new_resource.package_name do
            version new_resource.package_version
            action :remove
          end
        end
      end
    end
  end
end
