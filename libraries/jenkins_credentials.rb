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
require 'securerandom'

module JenkinsClusterCookbook
  module Resource
    # @action create
    # @action remove
    # @provides jenkins_credentials
    # @since 1.0
    class JenkinsCredentials < Chef::Resource
      include Poise
      provides(:jenkins_credentials)
      default_action(:create)
      actions(:create, :remove)

      # @!attribute id
      # @return [String]
      property(:id, kind_of: String, default: lazy { SecureRandom.uuid })
      # @!attribute description
      # @return [String]
      property(:description, kind_of: String)

      # @return [TrueClass, FalseClass]
      def sensitive
        true
      end
    end
  end

  module Provider
    # @action create
    # @action remove
    # @since 1.0
    class JenkinsCredentials < Chef::Provider
      include Poise
      provides(:jenkins_credentials)

      def action_create
        notifying_block do
          jenkins_script "Create #{new_resource}" do
            content <<-EOG.gsub(/ ^{12}/, '')
            import jenkins.model.*
            import com.cloudbees.plugins.credentials.*
            import com.cloudbees.plugins.credentials.impl.*
            import com.cloudbees.plugins.credentials.domains.*
            import hudson.plugins.sshslaves.*
            global_domain = Domain.global()
            credentials_store =
              Jenkins.instance.getExtensionList(
                'com.cloudbees.plugins.credentials.SystemCredentialsProvider'
              )[0].getStore()
            #{credentials_groovy}
            #{fetch_existing_credentials_groovy('existing_credentials')}
            if(existing_credentials != null) {
              credentials_store.updateCredentials(
                global_domain,
                existing_credentials,
                credentials
              )
            } else {
              credentials_store.addCredentials(global_domain, credentials)
            }
            EOG
          end
        end
      end

      def action_remove
        notifying_block do
          jenkins_script "Delete #{new_resource}" do
            content <<-EOG.gsub(/ ^{12}/, '')
            import jenkins.model.*
            import com.cloudbees.plugins.credentials.*;
            global_domain = com.cloudbees.plugins.credentials.domains.Domain.global()
            credentials_store =
              Jenkins.instance.getExtensionList(
                'com.cloudbees.plugins.credentials.SystemCredentialsProvider'
              )[0].getStore()
            #{fetch_existing_credentials_groovy('existing_credentials')}
            if(existing_credentials != null) {
              credentials_store.removeCredentials(
                global_domain,
                existing_credentials
              )
            }
            EOG
          end
        end
      end
    end
  end
end
