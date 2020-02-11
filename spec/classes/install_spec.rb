# frozen_string_literal: true

require 'spec_helper'

describe 'apics::install' do
  let(:params) do
    {
      'user'                   => 'oracle',
      'group'                  => 'oracle',
      'manage_user'            => true,
      'manage_group'           => true,
      'basedir'                => '/opt/oracle',
      'installer_source'       => '/path/to/ApicsGatewayInstaller.zip',
      'installer_target'       => '/tmp/ApicsGatewayInstaller.zip',
      'installer_extract_path' => '/opt/oracle/installer',
      'installer_cleanup'      => false,
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

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
