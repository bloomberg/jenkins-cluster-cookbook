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
require_relative 'jenkins_credentials'

module JenkinsClusterCookbook
  module Resource
    # @since 1.0
    class JenkinsCredentialsSecretText < JenkinsCredentials
      include Poise
      provides(:jenkins_credentials_secret_text)

      property(:description, kind_of: String, name_property: true)
      property(:secret, kind_of: String, required: true)
    end
  end

  module Provider
    # @since 1.0
    class JenkinsCredentialsSecretText < JenkinsCredentials
      include Poise
      provides(:jenkins_credentials_secret_text)

      # @return [String]
      def credentials_groovy
        <<-EOG.gsub(/ ^{8}/, '')
        credentials = new org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl(
                CredentialsScope.GLOBAL,
                '#{new_resource.id}',
                '#{new_resource.description}',
                new hudson.util.Secret('#{new_resource.secret}'))
        EOG
      end
    end
  end
end
