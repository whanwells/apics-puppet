# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'apics::gateway_installer define' do
  let(:manifest) do
    <<-PUPPET
      apics::gateway_installer { '/opt/installer':
        ensure => present,
        owner  => 'root',
        group  => 'root',
        source => '/tmp/ApicsGatewayInstaller.zip',
      }
      PUPPET
  end

  it 'applies idempotently' do
    idempotent_apply(manifest)
  end

  describe file('/opt/installer') do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by('root') }
    it { is_expected.to be_grouped_into('root') }
    it { is_expected.to be_mode(700) }
  end

  describe file('/opt/installer/APIGateway') do
    it { is_expected.to be_file }
  end
end
