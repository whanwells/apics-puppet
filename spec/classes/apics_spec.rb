# frozen_string_literal: true

require 'spec_helper'

describe 'apics' do
  let(:node) { 'test.example.com' }

  let(:params) do
    {
      'installer_source'       => '/path/to/ApicsGatewayInstaller.zip',
      'management_service_url' => 'https://test.apiplatform.ocp.example.com',
      'idcs_url'               => 'https://idcs.example.com/oauth2/v1/token',
      'request_scope'          => 'https://apiplatform.example.com.apiplatform offline_access',
      'gateway_node_name'      => 'Test Node',
    }
  end

  let(:gateway_props) do
    {
      'logicalGatewayId'          => 100,
      'logicalGateway'            => nil,
      'managementServiceUrl'      => 'https://test.apiplatform.ocp.example.com',
      'idcsUrl'                   => 'https://idcs.example.com/oauth2/v1/token',
      'requestScope'              => 'https://apiplatform.example.com.apiplatform offline_access',
      'gatewayNodeName'           => 'Test Node',
      'gatewayNodeDescription'    => nil,
      'listenIpAddress'           => '172.16.254.254',
      'publishAddress'            => 'test.example.com',
      'nodeInstallDir'            => '/opt/oracle/gateway',
      'gatewayExecutionMode'      => 'Development',
      'heapSizeGb'                => 2,
      'maximumHeapSizeGb'         => 4,
      'gatewayMServerPort'        => 8011,
      'gatewayMServerSSLPort'     => 9022,
      'nodeManagerPort'           => 5556,
      'coherencePort'             => 8088,
      'gatewayDBPort'             => 1527,
      'gatewayAdminServerPort'    => 8001,
      'gatewayAdminServerSSLPort' => 9021,
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

      it do
        is_expected.to contain_class('apics::config').with(
          'user'               => 'oracle',
          'group'              => 'oracle',
          'gateway_props'      => gateway_props,
          'gateway_props_path' => '/opt/oracle/installer/gateway-props.json',
        )
      end
    end
  end
end
