require 'spec_helper'
describe 'npmo' do

  context 'with defaults for all parameters' do
    it { should contain_class('npmo') }
  end
end
