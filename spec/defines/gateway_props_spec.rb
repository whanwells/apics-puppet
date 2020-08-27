# frozen_string_literal: true

require 'spec_helper'

describe 'apics::gateway_props' do
  let(:title) { '/tmp/gateway-props.json' }

  let(:params) do
    {
      'ensure' => 'present',
      'owner'  => 'oracle',
      'group'  => 'oracle',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it do
        is_expected.to contain_file(title).with(
          'ensure'    => 'present',
          'owner'     => 'oracle',
          'group'     => 'oracle',
          'mode'      => '0400',
          'show_diff' => false,
          'content'   => "{\n}\n",
        )
      end

      context 'when path is provided' do
        let(:params) { super().merge('path' => '/path/to/gateway-props.json') }

        it { is_expected.not_to contain_file('/tmp/gateway-props.json') }
        it { is_expected.to contain_file('/path/to/gateway-props.json') }
      end

      context 'when a property is a string' do
        let(:params) { super().merge('content' => { 'foo' => 'bar' }) }

        it { is_expected.to contain_file(title).with_content("{\n  \"foo\": \"bar\"\n}\n") }
      end

      context 'when a property is an integer' do
        let(:params) { super().merge('content' => { 'foo' => 1 }) }

        it { is_expected.to contain_file(title).with_content("{\n  \"foo\": \"1\"\n}\n") }
      end

      context 'when a property is undef' do
        let(:params) { super().merge('content' => { 'foo' => :undef }) }

        it { is_expected.to contain_file(title).with_content("{\n}\n") }
      end

      context 'when a property is an array' do
        let(:params) { super().merge('content' => { 'foo' => ['bar'] }) }

        it { is_expected.to contain_file(title).with_content("{\n  \"foo\": [\n    \"bar\"\n  ]\n}\n") }
      end
    end
  end
end
