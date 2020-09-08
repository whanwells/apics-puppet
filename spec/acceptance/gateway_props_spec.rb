# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'apics::gateway_props define' do
  let(:manifest) do
    <<-PUPPET
      apics::gateway_props { '/tmp/gateway-props.json':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        content => {
          'nodeInstallDir' => '/opt/oracle/gateway',
        }
      }
    PUPPET
  end

  it 'applies idempotently' do
    idempotent_apply(manifest)
  end

  describe file('/tmp/gateway-props.json') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by('root') }
    it { is_expected.to be_grouped_into('root') }
    it { is_expected.to be_mode(400) }
    its(:content) { is_expected.to match(%r{"nodeInstallDir": "/opt/oracle/gateway"}) }
  end
end
