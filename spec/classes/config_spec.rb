# frozen_string_literal: true

require 'spec_helper'

describe 'apics::config' do
  let(:params) do
    {
      'user'                            => 'oracle',
      'group'                           => 'oracle',
      'gateway_props_path'              => '/opt/oracle/installer/gateway-props.json',
      'logical_gateway_id'              => :undef,
      'management_service_url'          => 'https://test.apiplatform.ocp.example.com',
      'idcs_url'                        => 'https://idcs.example.com/oauth2/v1/token',
      'request_scope'                   => 'https://apiplatform.example.com.apiplatform offline_access',
      'gateway_node_name'               => 'Test Node',
      'gateway_node_description'        => :undef,
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
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it do
        is_expected.to contain_file('/opt/oracle/installer/gateway-props.json').with(
          'ensure'  => 'present',
          'owner'   => 'oracle',
          'group'   => 'oracle',
          'mode'    => '0440',
          'content' => file_fixture('gateway-props.json'),
        )
      end

      context 'with logical_gateway_id => 1' do
        let(:params) { super().merge('logical_gateway_id' => 1) }

        it { is_expected.to contain_file('/opt/oracle/installer/gateway-props.json').with_content(%r{"logicalGatewayId": "1"}) }
      end

      context "with gateway_node_description => 'Test Node'" do
        let(:params) { super().merge('gateway_node_description' => 'Test Node') }

        it { is_expected.to contain_file('/opt/oracle/installer/gateway-props.json').with_content(%r{"gatewayNodeDescription": "Test Node"}) }
      end
    end
  end
end
