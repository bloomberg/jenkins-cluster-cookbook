#
# Cookbook: jenkins-cluster
# License: Apache 2.0
#
# Copyright 2010, VMware, Inc.
# Copyright 2013, Youscribe.
# Copyright 2012-2015, Chef Software, Inc.
# Copyright 2014-2016, Bloomberg Finance L.P.on_
#
require 'poise'
require 'poise_service/service_mixin'

module JenkinsClusterCookbook
  module Resource
    # @action enable
    # @action disable
    # @action start
    # @action stop
    # @action restart
    # @provides jenkins_service
    # @since 1.0
    class JenkinsService < Chef::Resource
      include Poise(container: true)
      provides(:jenkins_service)
      include PoiseService::ServiceMixin
      actions(:enable, :disable, :start, :stop, :restart)

      # @!attribute service_name
      # @return [String]
      property(:service_name, kind_of: String, name_property: true)
      # @!attribute user
      # @return [String]
      property(:user, kind_of: String, default: 'jenkins')
      # @!attribute directory
      # @return [String]
      property(:directory, kind_of: String, default: '/var/lib/jenkins')
      # @!attribute warfile
      # @return [String]
      property(:warfile, kind_of: String, required: true)

      # @return [String]
      def command
        "/usr/bin/java ${JENKINS_JAVA_OPTIONS} -jar #{warfile} --httpPort=${JENKINS_PORT} --httpListenAddress=${JENKINS_LISTEN_ADDRESS} ${JENKINS_ARGS}"
      end
    end
  end

  module Provider
    # @since 1.0
    class JenkinsService < Chef::Provider
      include Poise
      provides(:jenkins_service)
      include PoiseService::ServiceMixin

      private

      # @return [Chef::Resource]
      # @api private
      def service_options(resource)
        resource.command(new_resource.command)
        resource.user(new_resource.user)
        resource.directory(new_resource.directory)
        resource.options(:systemd, template: 'jenkins-cluster:systemd.service.erb')
      end
    end
  end
end
