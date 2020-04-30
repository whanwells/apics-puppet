require 'spec_helper'

describe 'Apics::GatewayAction' do
  it { is_expected.to allow_values('install', 'configure', 'start', 'creategateway', 'join') }
  it { is_expected.not_to allow_value('foo') }
end
