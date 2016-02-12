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
    # A resource which executes commands with the Jenkins CLI JAR.
    # @since 1.0
    class JenkinsCommand < Chef::Resource
      include Poise(fused: true)
      provides(:jenkins_command)

      property(:command, kind_of: [String, Array], name_attribute: true)
      property(:jar_path, kind_of: String, default: '/usr/share/jenkins/cli/java/cli.jar')
      property(:environment, option_collector: true, default: {})
      property(:options, option_collector: true, default: {})

      action(:execute) do
        command = ['/usr/bin/env java', new_resource.jar_path]
        command << ['-s', URI.escape(options[:endpoint])] if options[:endpoint]
        command << ['-p', URI.escape(options[:proxy])] if options[:proxy]
        command << ['-i', options[:key]] if options[:key]
        command << ['--username', options[:username]] if options[:username]
        command << ['--password', options[:password]] if options[:password]
        command << [new_resource.command]
        notifying_block do
          execute command.flatten.join(' ') do
            environment new_resource.environment
            sensitive true
          end
        end
      end
    end
  end
end
