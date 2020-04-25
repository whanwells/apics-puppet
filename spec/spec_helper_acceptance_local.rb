# frozen_string_literal: true

require 'singleton'
require 'puppet_litmus'

['APICS_GATEWAY_INSTALLER_SOURCE', 'JDK_RPM_SOURCE', 'JDK_RPM_VERSION'].each do |name|
  raise "Missing environment variable: #{name}" unless ENV[name]
end

# Fix undefined method 'facts_from_node' error
include PuppetLitmus

class LitmusHelper
  include Singleton
  include PuppetLitmus
end

RSpec.configure do |c|
  c.before(:suite) do
    # Upload gateway node installer
    LitmusHelper.instance.bolt_upload_file(ENV['APICS_GATEWAY_INSTALLER_SOURCE'], '/tmp/ApicsGatewayInstaller.zip')
    LitmusHelper.instance.bolt_upload_file(ENV['JDK_RPM_SOURCE'], '/tmp/jdk.rpm')
  end
end
