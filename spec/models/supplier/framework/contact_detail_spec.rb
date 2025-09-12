require 'rails_helper'

RSpec.describe Supplier::Framework::ContactDetail do
  describe 'associations' do
    let(:supplier_framework_contact_detail) { create(:supplier_framework_contact_detail) }

    it { is_expected.to belong_to(:supplier_framework) }

    it 'has the supplier_framework relationship' do
      expect(supplier_framework_contact_detail.supplier_framework).to be_present
    end
  end
end
