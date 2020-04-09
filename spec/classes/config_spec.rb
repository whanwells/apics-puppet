# frozen_string_literal: true

require 'spec_helper'

describe 'apics::config' do
  let(:gateway_props) do
    {
      'nodeInstallDir'  => '/ot/oracle/gateway',
      'listenIpAddress' => '172.16.254.254',
      'publishAddress'  => 'test.example.com',
    }
  end

  let(:params) do
    {
      'user'               => 'oracle',
      'group'              => 'oracle',
      'gateway_props'      => gateway_props,
      'gateway_props_path' => '/opt/oracle/installer/gateway-props.json',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it do
        is_expected.to contain_apics__gateway_props('/opt/oracle/installer/gateway-props.json').with(
          'ensure'  => 'present',
          'owner'   => 'oracle',
          'group'   => 'oracle',
          'mode'    => '0440',
          'props'   => gateway_props,
        )
      end
    end
  end
end
