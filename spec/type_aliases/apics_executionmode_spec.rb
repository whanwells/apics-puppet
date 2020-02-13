require 'spec_helper'

describe 'Apics::ExecutionMode' do
  it { is_expected.to allow_values('Development', 'Production') }
  it { is_expected.not_to allow_value('Test') }
end
