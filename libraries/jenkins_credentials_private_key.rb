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
require 'openssl'
require_relative 'jenkins_credentials'

module JenkinsClusterCookbook
  module Resource
    # @since 1.0
    class JenkinsCredentialsPrivateKey < JenkinsCredentials
      include Poise
      provides(:jenkins_credentials_private_key)

      property(:username, kind_of: String, name_property: true)
      property(:private_key, kind_of: [String, OpenSSL::PKey::RSA], required: true)
      property(:passphrase, kind_of: String, default: '')
    end
  end

  module Provider
    # @since 1.0
    class JenkinsCredentialsPrivateKey < JenkinsCredentials
      include Poise
      provides(:jenkins_credentials_private_key)

      def credentials_groovy
        <<-EOG.gsub(/ ^{8}/, '')
        import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
        key = """#{new_resource.private_key}
        """
        credentials = new BasicSSHUserPrivateKey(
                CredentialsScope.GLOBAL,
                '#{new_resource.id}',
                '#{new_resource.username}',
                new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(key),
                '#{new_resource.passphrase}',
                '#{new_resource.description}')
        EOG
      end
    end
  end
end
