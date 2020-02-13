# frozen_string_literal: true

require 'singleton'
require 'puppet_litmus'
require 'support/file_helper'

class LitmusHelper
  include Singleton
  include PuppetLitmus
end

RSpec.configure do |c|
  c.include FileHelper

  c.before(:suite) do
    # Install unzip package
    LitmusHelper.instance.apply_manifest("package { 'unzip': ensure => present }")

    # Upload gateway node installer
    installer = File.join(FileHelper.fixture_path, 'ApicsGatewayInstaller.zip')
    LitmusHelper.instance.bolt_upload_file(installer, '/tmp/ApicsGatewayInstaller.zip')
  end
end
