# frozen_string_literal: true

require 'spec_helper'

describe 'apics' do
  let(:params) do
    {
      'installer_source' => '/path/to/ApicsGatewayInstaller.zip',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it do
        is_expected.to contain_class('apics::install').with(
          'user'                   => 'oracle',
          'group'                  => 'oracle',
          'manage_user'            => true,
          'manage_group'           => true,
          'basedir'                => '/opt/oracle',
          'installer_source'       => '/path/to/ApicsGatewayInstaller.zip',
          'installer_target'       => '/tmp/ApicsGatewayInstaller.zip',
          'installer_extract_path' => '/opt/oracle/installer',
          'installer_cleanup'      => false,
        )
      end
    end
  end
end
