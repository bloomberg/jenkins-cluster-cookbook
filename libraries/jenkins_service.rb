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
require 'poise_service/service_mixin'

module JenkinsClusterCookbook
  module Resource
    # @since 1.0
    class JenkinsService < Chef::Resource
      include Poise(container: true)
      provides(:jenkins_service)
      include PoiseService::ServiceMixin
      actions(:enable, :disable, :start, :stop, :restart)

      property(:service_name, kind_of: String, name_property: true)
      property(:user, kind_of: String, default: 'jenkins')
      property(:directory, kind_of: String, default: '/var/lib/jenkins')
      property(:warfile, kind_of: String, required: true)

      def command
        "/usr/bin/env java -jar #{warfile}"
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
      def service_options(resource)
        resource.service_name(new_resource.service_name)
        resource.command(new_resource.command)
        resource.user(new_resource.user)
        resource.directory(new_resource.directory)
      end
    end
  end
end
