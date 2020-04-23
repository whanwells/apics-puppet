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
      it { is_expected.to contain_class('apics::install') }
      it { is_expected.to contain_class('apics::config') }

      ['/opt/oracle', '/opt/oracle/installer'].each do |dir|
        it do
          is_expected.to contain_file(dir).with(
            'ensure' => 'directory',
            'owner'  => 'oracle',
            'group'  => 'oracle',
            'mode'   => '0755',
          )
        end
      end

      it do
        is_expected.to contain_archive('/tmp/ApicsGatewayInstaller.zip').with(
          'source'       => '/path/to/ApicsGatewayInstaller.zip',
          'extract'      => true,
          'extract_path' => '/opt/oracle/installer',
          'user'         => 'oracle',
          'creates'      => '/opt/oracle/installer/APIGateway',
          'cleanup'      => false,
        )
      end

      it do
        is_expected.to contain_apics__gateway_props('/opt/oracle/installer/gateway-props.json').with(
          'ensure'  => 'present',
          'owner'   => 'oracle',
          'group'   => 'oracle',
          'mode'    => '0440',
          'props'   => gateway_props,
        )
      end

      context 'with manage_user => true' do
        let(:params) { super().merge('manage_user' => true) }

        it do
          is_expected.to contain_user('oracle').with(
            'ensure' => 'present',
            'gid'    => 'oracle',
          )
        end
      end

      context 'with manage_user => false' do
        let(:params) { super().merge('manage_user' => false) }

        it { is_expected.not_to contain_user('oracle') }
      end

      context 'with manage_group => true' do
        let(:params) { super().merge('manage_group' => true) }

        it { is_expected.to contain_group('oracle').with_ensure('present') }
      end

      context 'with manage_group => false' do
        let(:params) { super().merge('manage_group' => false) }

        it { is_expected.not_to contain_group('oracle') }
      end
    end
  end
end
