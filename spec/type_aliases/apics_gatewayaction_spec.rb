require 'spec_helper'

describe 'Apics::GatewayAction' do
  it { is_expected.to allow_values('install', 'configure', 'start') }
  it { is_expected.not_to allow_value('foo') }
end
