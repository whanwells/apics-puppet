# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'api_platform class' do
  let(:pp) do
    <<-MANIFEST
      class { 'apics':
        gateway_node_name      => 'Test Node',
        management_service_url => 'https://test.apiplatform.ocp.example.com',
        idcs_url               => 'https://idcs.example.com/oauth2/v1/token',
        request_scope          => 'https://apiplatform.example.com.apiplatform offline_access',
        installer_source       => '/path/to/ApicsGatewayInstaller.zip',
        listen_ip_address      => '172.16.254.254',
        publish_address        => 'test.example.com',
      }
    MANIFEST
  end

  let(:gateway_props) { file_fixture('gateway-props.json') }

  it 'applies idempotently' do
    idempotent_apply(pp)
  end

  describe user('oracle') do
    it { is_expected.to exist }
    it { belong_to_primary_group('oracle') }
  end

  describe group('oracle') do
    it { is_expected.to exist }
  end

  ['/opt/oracle', '/opt/oracle/installer'].each do |dir|
    describe file(dir) do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by('oracle') }
      it { is_expected.to be_grouped_into('oracle') }
      it { is_expected.to be_mode(755) }
    end
  end

  describe file('/opt/oracle/installer/APIGateway') do
    it { is_expected.to be_file }
  end

  describe file('/opt/oracle/installer/gateway-props.json') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by('oracle') }
    it { is_expected.to be_grouped_into('oracle') }
    it { is_expected.to be_mode(440) }
    its(:content) { is_expected.to match(gateway_props) }
  end
end
