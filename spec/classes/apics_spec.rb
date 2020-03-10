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
          'user'                            => 'oracle',
          'group'                           => 'oracle',
          'gateway_props_path'              => '/opt/oracle/installer/gateway-props.json',
          'logical_gateway_id'              => 100,
          'logical_gateway'                 => nil,
          'management_service_url'          => 'https://test.apiplatform.ocp.example.com',
          'idcs_url'                        => 'https://idcs.example.com/oauth2/v1/token',
          'request_scope'                   => 'https://apiplatform.example.com.apiplatform offline_access',
          'gateway_node_name'               => 'Test Node',
          'gateway_node_description'        => nil,
          'listen_ip_address'               => '172.16.254.254',
          'publish_address'                 => 'test.example.com',
          'node_install_dir'                => '/opt/oracle/gateway',
          'gateway_execution_mode'          => 'Development',
          'heap_size_gb'                    => 2,
          'maximum_heap_size_gb'            => 4,
          'gateway_managed_server_port'     => 8011,
          'gateway_managed_server_ssl_port' => 9022,
          'node_manager_port'               => 5556,
          'coherence_port'                  => 8088,
          'gateway_db_port'                 => 1527,
          'gateway_admin_server_port'       => 8001,
          'gateway_admin_server_ssl_port'   => 9021,
        )
      end
    end
  end
end
