# frozen_string_literal: true

require 'spec_helper'

describe 'apics::install' do
  let(:params) do
    {
      'user'         => 'oracle',
      'group'        => 'oracle',
      'manage_user'  => true,
      'manage_group' => true,
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

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
