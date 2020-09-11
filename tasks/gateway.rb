#!/opt/puppetlabs/puppet/bin/ruby

require 'open3'
require 'pathname'
require_relative '../../ruby_task_helper/files/task_helper.rb'

# Executes a gateway action.
class GatewayTask < TaskHelper
  def task(params)
    path = Pathname.new(params[:path])

    raise ArgumentError, 'path must be absolute' unless path.absolute?
    raise ArgumentError, 'path must be a directory' unless path.directory?

    env = { 'JAVA_HOME' => params[:java_home] }
    cmd = [File.join(params[:path], 'APIGateway'), '-f', params[:file], '-a', params[:action]]

    if params.key?(:loglevel) && !params[:loglevel].nil?
      cmd << '-l'
      cmd << params[:loglevel].upcase
    end

    if params.key?(:keyvalue) && !params[:keyvalue].nil?
      cmd.push('-kv', *params[:keyvalue])
    end

    Open3.popen2e(env, *cmd, chdir: params[:path]) do |stdin, stdout_stderr, wait_thread|
      Thread.new do
        stdout_stderr.each { |line| puts line }
      end

      stdin.close
      wait_thread.join
      nil
    end
  end
end

if $PROGRAM_NAME == __FILE__
  GatewayTask.run
end
