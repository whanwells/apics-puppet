# frozen_string_literal: true

require 'spec_helper'

describe 'apics::gateway_installer' do
  let(:title) { '/opt/installer' }
  let(:params) do
    {
      'ensure' => 'present',
      'owner'  => 'oracle',
      'group'  => 'oracle',
      'source' => '/tmp/ApicsGatewayInstaller.zip',
    }
  end

  shared_examples 'a gateway installer' do |path|
    context 'with ensure => present' do
      it do
        is_expected.to contain_file(path).with(
          'ensure' => 'directory',
          'owner'  => 'oracle',
          'group'  => 'oracle',
          'mode'   => '0700',
        )
      end

      it do
        is_expected.to contain_archive('/tmp/ApicsGatewayInstaller.zip').with(
          'source'       => '/tmp/ApicsGatewayInstaller.zip',
          'extract'      => true,
          'extract_path' => path,
          'user'         => 'oracle',
          'group'        => 'oracle',
          'creates'      => "#{path}/APIGateway",
          'cleanup'      => false,
        )
      end

      context 'with force => true' do
        let(:params) { super().merge('force' => true) }

        it { is_expected.to contain_archive('/tmp/ApicsGatewayInstaller.zip').with_creates(nil) }
      end
    end

    context 'with ensure => absent' do
      let(:params) { super().merge('ensure' => 'absent') }

      it do
        is_expected.to contain_file(path).with(
          'ensure'  => 'absent',
          'recurse' => true,
          'purge'   => true,
          'force'   => true,
        )
      end
    end
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it_behaves_like 'a gateway installer', '/opt/installer'

      context 'when path is provided' do
        let(:params) { super().merge('path' => '/home/foo/installer') }

        it_behaves_like 'a gateway installer', '/home/foo/installer'
      end
    end
  end
end
