require 'spec_helper'

describe 'Apics::GatewayProps' do
  it { is_expected.to allow_value(logicalGatewayId: 100) }
  it { is_expected.to allow_value(logicalGateway: 'Test') }
  it { is_expected.to allow_value(managementServiceUrl: 'https://test.apiplatform.ocp.example.com') }
  it { is_expected.to allow_value(idcsUrl: 'https://idcs.example.com/oauth2/v1/token') }
  it { is_expected.to allow_value(requestScope: 'https://apiplatform.example.com.apiplatform offline_access') }
  it { is_expected.to allow_value(gatewayNodeName: 'Test Node') }
  it { is_expected.to allow_value(gatewayNodeDescription: nil) }
  it { is_expected.to allow_value(listenIpAddress: '172.16.254.254') }
  it { is_expected.to allow_value(publishAddress: 'test.example.com') }
  it { is_expected.to allow_value(nodeInstallDir: '/opt/oracle/gateway') }
  it { is_expected.to allow_value(gatewayExecutionMode: 'Development') }
  it { is_expected.to allow_value(heapSizeGb: 2) }
  it { is_expected.to allow_value(maximumHeapSizeGb: 4) }
  it { is_expected.to allow_value(gatewayMServerPort: 8011) }
  it { is_expected.to allow_value(gatewayMServerSSLPort: 9022) }
  it { is_expected.to allow_value(nodeManagerPort: 5556) }
  it { is_expected.to allow_value(coherencePort: 8088) }
  it { is_expected.to allow_value(gatewayDBPort: 1527) }
  it { is_expected.to allow_value(gatewayAdminServerPort: 8001) }
  it { is_expected.to allow_value(gatewayAdminServerSSLPort: 9021) }

  it { is_expected.not_to allow_value(foo: 'bar') }
end
