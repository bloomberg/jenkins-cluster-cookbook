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
require 'tempfile'

module JenkinsClusterCookbook
  module Resource
    # A `jenkins_script` resource which executes Groovy on the command-line.
    # @provides execute
    # @since 1.0
    class JenkinsScript < Chef::Resource
      include Poise(fused: true)
      provides(:jenkins_script)

      property('', template: true)
      property(:path, kind_of: String, default: lazy { Tempfile.new('groovy').path })
      property(:owner, kind_of: String, default: 'jenkins')
      property(:group, kind_of: String, default: 'jenkins')
      property(:mode, kind_of: String, default: '0400')

      def sensitive
        true
      end

      action(:execute) do
        notifying_block do
          file new_resource.path do
            content new_resource.content
            owner new_resource.owner
            group new_resource.group
            mode new_resource.mode
          end

          jenkins_command "groovy #{new_resource.path}" do
            notifies :delete, "file[#{new_resource.path}]", :immediately
          end
        end
      end
    end
  end
end
