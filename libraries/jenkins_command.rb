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
    # A `jenkins_command` resource which executes a Java command using
    # the Jenkins CLI.
    # @provides execute
    # @since 1.0
    class JenkinsCommand < Chef::Resource
      include Poise(fused: true)
      provides(:jenkins_command)

      # @!attribute command
      # @return [String]
      property(:command, kind_of: [String, Array], name_attribute: true)
      # @!attribute jarfile
      # @return [String]
      property(:jarfile, kind_of: String, default: '/usr/local/share/jenkins/cli/java/cli.jar')
      # @!attribute environment
      # @return [Hash]
      property(:environment, option_collector: true, default: {})
      # @!attribute options
      # @return [Hash]
      property(:options, option_collector: true, default: {})

      action(:execute) do
        options = new_resource.options
        endpoint = options[:endpoint] || 'http://127.0.0.1:8080'

        command = ['/usr/bin/env java -jar', new_resource.jarfile]
        command << ['-s', URI.escape(endpoint)]
        command << ['-p', URI.escape(options[:proxy])] if options[:proxy]
        command << ['-i', options[:key]] if options[:key]
        command << ['--username', options[:username]] if options[:username]
        command << ['--password', options[:password]] if options[:password]
        command << [new_resource.command]
        notifying_block do
          directory ::File.dirname(new_resource.jarfile) do
            recursive true
          end

          remote_file new_resource.jarfile do
            source URI.join(endpoint, '/jnlpJars/jenkins-cli.jar').to_s
            action :create_if_missing
          end

          bash new_resource.command do
            code command.flatten.join(' ')
            environment new_resource.environment
            timeout options[:timeout]
            sensitive true
          end
        end
      end
    end
  end
end
