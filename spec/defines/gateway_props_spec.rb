# frozen_string_literal: true

require 'spec_helper'

describe 'apics::gateway_props' do
  let(:title) { '/tmp/gateway-props.json' }

  let(:params) do
    {
      'ensure' => 'present',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'when the base apics class is not defined' do
        it { is_expected.to compile.and_raise_error(%r{You must include the base apics class before using any of its defined resources}) }
      end

      context 'when the base apics class is defined' do
        let(:pre_condition) { 'include apics' }

        it { is_expected.to compile }
        it { is_expected.to contain_apics__gateway_props(title).that_requires('Class[apics::install]') }

        it do
          is_expected.to contain_file('/tmp/gateway-props.json').with(
            'ensure'    => 'present',
            'owner'     => 'oracle',
            'group'     => 'oracle',
            'mode'      => '0400',
            'content'   => "{\n}\n",
            'show_diff' => false,
          )
        end

        context 'with path defined' do
          let(:params) { super().merge('path' => '/path/to/gateway-props.json') }

          it { is_expected.to contain_file('/path/to/gateway-props.json') }
        end

        context 'when prop value is string' do
          let(:params) { super().merge('content' => { 'nodeInstallDir' => '/opt/oracle/gateway' }) }

          it { is_expected.to contain_file('/tmp/gateway-props.json').with_content(%r{"nodeInstallDir": "/opt/oracle/gateway"}) }
        end

        context 'when prop value is integer' do
          let(:params) { super().merge('content' => { 'heapSizeGb' => 2 }) }

          it { is_expected.to contain_file('/tmp/gateway-props.json').with_content(%r{"heapSizeGb": "2"}) }
        end

        context 'when prop value is undef' do
          let(:params) { super().merge('content' => { 'logicalGateway' => :undef }) }

          it { is_expected.to contain_file('/tmp/gateway-props.json').with_content(%r{(?!logicalGateway)}) }
        end
      end
    end
  end
end
