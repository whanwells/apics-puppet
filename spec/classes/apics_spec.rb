# frozen_string_literal: true

require 'spec_helper'

describe 'apics' do
  let(:node) { 'test.example.com' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('apics::install') }
      it { is_expected.to contain_class('apics::config') }
      it { is_expected.to contain_class('apics::deploy') }

      ['/opt/oracle', '/opt/oracle/installer'].each do |dir|
        it do
          is_expected.to contain_file(dir).with(
            'ensure' => 'directory',
            'owner'  => 'oracle',
            'group'  => 'oracle',
            'mode'   => '0700',
          )
        end
      end

      it do
        is_expected.to contain_archive('/tmp/ApicsGatewayInstaller.zip').with(
          'source'       => '/tmp/ApicsGatewayInstaller.zip',
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
          'props'   => {
            'logicalGatewayId'          => 100,
            'logicalGateway'            => nil,
            'managementServiceUrl'      => nil,
            'idcsUrl'                   => nil,
            'requestScope'              => nil,
            'gatewayNodeName'           => 'test',
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
            'gatewayadminName'          => 'weblogic',
            'gatewayadminPassword'      => 'Welcome1',
          },
        )
      end

      it { is_expected.to contain_apics__gateway_exec('deploy-install').with_action('install') }
      it { is_expected.to contain_apics__gateway_exec('deploy-configure').with_action('configure') }
      it { is_expected.to contain_apics__gateway_exec('deploy-start').with_action('start') }

      context 'with manage_user => true' do
        let(:params) { { 'manage_user' => true } }

        it do
          is_expected.to contain_user('oracle').with(
            'ensure' => 'present',
            'gid'    => 'oracle',
          )
        end
      end

      context 'with manage_user => false' do
        let(:params) { { 'manage_user' => false } }

        it { is_expected.not_to contain_user('oracle') }
      end

      context 'with manage_group => true' do
        let(:params) { { 'manage_group' => true } }

        it { is_expected.to contain_group('oracle').with_ensure('present') }
      end

      context 'with manage_group => false' do
        let(:params) { { 'manage_group' => false } }

        it { is_expected.not_to contain_group('oracle') }
      end

      context 'with manage_unzip => true' do
        let(:params) { { 'manage_unzip_package' => true } }

        it { is_expected.to contain_package('unzip').with_ensure('present') }
      end

      context 'with manage_unzip => false' do
        let(:params) { { 'manage_unzip_package' => false } }

        it { is_expected.not_to contain_package('unzip') }
      end
    end
  end
end
