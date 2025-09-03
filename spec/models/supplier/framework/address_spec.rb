require 'rails_helper'

RSpec.describe Supplier::Framework::Address do
  describe 'associations' do
    let(:supplier_framework_address) { create(:supplier_framework_address) }

    it { is_expected.to belong_to(:supplier_framework) }

    it 'has the supplier_framework relationship' do
      expect(supplier_framework_address.supplier_framework).to be_present
    end
  end
end
