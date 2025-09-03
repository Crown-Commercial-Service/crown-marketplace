require 'rails_helper'

RSpec.describe Upload do
  describe 'associations' do
    it { is_expected.to belong_to(:framework) }
  end
end
