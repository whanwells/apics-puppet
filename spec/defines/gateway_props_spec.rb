# frozen_string_literal: true

require 'spec_helper'

describe 'apics::gateway_props' do
  let(:title) { '/tmp/gateway-props.json' }

  let(:params) do
    {
      'ensure' => 'present',
      'owner'  => 'oracle',
      'group'  => 'oracle',
      'mode'   => '0444',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      context 'with minimum parameters' do
        it do
          is_expected.to contain_file('/tmp/gateway-props.json').with(
            'ensure'    => 'present',
            'owner'     => 'oracle',
            'group'     => 'oracle',
            'mode'      => '0444',
            'content'   => "{\n}\n",
            'show_diff' => false,
          )
        end
      end

      context 'with path => /path/to/gateway-props.json' do
        let(:params) { super().merge('path' => '/path/to/gateway-props.json') }

        it { is_expected.to contain_file('/path/to/gateway-props.json') }
      end

      context 'when prop value is string' do
        let(:params) { super().merge('props' => { 'nodeInstallDir' => '/opt/oracle/gateway' }) }

        it { is_expected.to contain_file('/tmp/gateway-props.json').with_content(%r{"nodeInstallDir": "/opt/oracle/gateway"}) }
      end

      context 'when prop value is integer' do
        let(:params) { super().merge('props' => { 'heapSizeGb' => 2 }) }

        it { is_expected.to contain_file('/tmp/gateway-props.json').with_content(%r{"heapSizeGb": "2"}) }
      end

      context 'when prop value is undef' do
        let(:params) { super().merge('props' => { 'logicalGateway' => :undef }) }

        it { is_expected.to contain_file('/tmp/gateway-props.json').with_content(%r{(?!logicalGateway)}) }
      end
    end
  end
end
