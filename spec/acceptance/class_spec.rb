# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'api_platform class' do
  let(:manifest) do
    <<-PP
      class { 'apics':
        heap_size_gb         => 1,
        maximum_heap_size_gb => 1,
        jdk_package_version  => '#{ENV['JDK_RPM_VERSION']}',
      }
    PP
  end

let(:gateway_props) do
  <<-EOF
{
  "logicalGatewayId": "100",
  "gatewayNodeName": "#{host_inventory['hostname']}",
  "listenIpAddress": "#{host_inventory['facter']['networking']['ip']}",
  "publishAddress": "#{host_inventory['facter']['networking']['fqdn']}",
  "nodeInstallDir": "/opt/oracle/gateway",
  "gatewayExecutionMode": "Development",
  "heapSizeGb": "1",
  "maximumHeapSizeGb": "1",
  "gatewayMServerPort": "8011",
  "gatewayMServerSSLPort": "9022",
  "nodeManagerPort": "5556",
  "coherencePort": "8088",
  "gatewayDBPort": "1527",
  "gatewayAdminServerPort": "8001",
  "gatewayAdminServerSSLPort": "9021",
  "gatewayadminName": "weblogic",
  "gatewayadminPassword": "Welcome1"
}
EOF
    end

  it 'applies idempotently' do
    idempotent_apply(manifest)
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
      it { is_expected.to be_mode(700) }
    end
  end

  describe file('/opt/oracle/installer/APIGateway') do
    it { is_expected.to be_file }
  end

  describe file('/opt/oracle/installer/gateway-props.json') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by('oracle') }
    it { is_expected.to be_grouped_into('oracle') }
    it { is_expected.to be_mode(400) }
    its(:content) { is_expected.to match(gateway_props) }
  end

  describe file('/opt/oracle/gateway/GATEWAY_HOME/installocsg.marker') do
    it { is_expected.to be_file }
  end

  describe file('/opt/oracle/gateway/domain/gateway1/ocsgDomainCreation.marker') do
    it { is_expected.to be_file }
  end

  [8011, 9022, 8001, 9021].each do |port|
    describe port(port) do
      it { should be_listening.with('tcp') }
    end
  end
end
