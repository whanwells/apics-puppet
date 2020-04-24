# frozen_string_literal: true

require 'spec_helper'

describe 'apics::gateway_exec' do
  let(:title) { 'install' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'when the base apics class is not defined' do
        it { is_expected.to compile.and_raise_error(%r{You must include the base apics class before using any of its defined resources}) }
      end

      context 'when the base apics class is defined' do
        let(:pre_condition) { 'include apics' }

        it { is_expected.to compile }
        it { is_expected.to contain_apics__gateway_exec(title).that_requires('Class[apics::config]') }

        it do
          is_expected.to contain_exec('apics_gateway_exec_install').with(
            'command'     => 'APIGateway -f gateway-props.json -a install',
            'user'        => 'oracle',
            'cwd'         => '/opt/oracle/installer',
            'path'        => ['/bin', '/opt/oracle/installer'],
            'environment' => ['JAVA_HOME=/usr/java/default'],
          )
        end

        context 'with action => install' do
          let(:params) { { 'action' => 'install' } }

          it do
            is_expected.to contain_exec('apics_gateway_exec_install').with(
              'command' => %r{-a install},
              'creates' => '/opt/oracle/gateway/GATEWAY_HOME/installocsg.marker',
              'unless'  => nil,
            )
          end
        end

        context 'with action => configure' do
          let(:params) { { 'action' => 'configure' } }

          it do
            is_expected.to contain_exec('apics_gateway_exec_install').with(
              'command' => %r{-a configure},
              'creates' => '/opt/oracle/gateway/domain/gateway1/ocsgDomainCreation.marker',
              'unless'  => nil,
            )
          end
        end

        context 'with action => start' do
          let(:params) { { 'action' => 'start' } }

          it do
            is_expected.to contain_exec('apics_gateway_exec_install').with(
              'command' => %r{-a start},
              'creates' => nil,
              'unless'  => 'APIGateway -f gateway-props.json -a status | grep "gateway server: running"',
            )
          end
        end
      end
    end
  end
end
