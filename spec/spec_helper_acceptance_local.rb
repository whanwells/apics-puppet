# frozen_string_literal: true

require 'singleton'
require 'puppet_litmus'

# Fix undefined method 'facts_from_node' error
include PuppetLitmus

class LitmusHelper
  include Singleton
  include PuppetLitmus
end

RSpec.configure do |c|
  file_path = File.expand_path('fixtures/files', __dir__)

  c.before(:suite) do
    # Install unzip
    LitmusHelper.instance.apply_manifest("package { 'unzip': ensure => present }")

    # Upload gateway node installer
    installer_path = File.join(file_path, 'ApicsGatewayInstaller.zip')
    LitmusHelper.instance.bolt_upload_file(installer_path, '/tmp/ApicsGatewayInstaller.zip')
  end
end
