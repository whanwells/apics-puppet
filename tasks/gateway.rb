#!/opt/puppetlabs/puppet/bin/ruby

require 'open3'
require 'pathname'
require 'timeout'
require_relative '../../ruby_task_helper/files/task_helper.rb'

# Executes a gateway action.
class GatewayTask < TaskHelper
  def task(params)
    path = Pathname.new(params[:path])

    raise ArgumentError, 'path must be absolute' unless path.absolute?
    raise ArgumentError, 'path must be a directory' unless path.directory?

    env = { 'JAVA_HOME' => params[:java_home] }
    cmd = [File.join(params[:path], 'APIGateway'), '-f', params[:file], '-a', params[:action]]

    if params.key?(:loglevel)
      cmd << '-l'
      cmd << params[:loglevel].upcase
    end

    if params.key?(:keyvalue)
      cmd << '-kv'
      params[:keyvalue].each do |k, v|
        cmd << "#{k}=#{v}"
      end
    end

    timeout = params.key?(:timeout) ? params[:timeout] : 300

    execute(env, cmd, params[:path], timeout)
  end

  private

  def execute(env, cmd, chdir, timeout)
    Open3.popen2e(env, *cmd, chdir: chdir) do |_, output, wait_thread|
      begin
        Timeout.timeout(timeout) do
          puts output.gets until output.eof?
        end
      rescue Timeout::Error
        Process.kill('KILL', wait_thread.pid)
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  GatewayTask.run
end
