require 'rails_helper'

RSpec.describe FacilitiesManagement::SupplierEmailReplacement do
  let(:supplier) { create(:ccs_fm_supplier) }
  let(:supplier_detail) { create(:facilities_management_supplier_detail, contact_email: supplier.contact_email) }
  let(:email_replacements) { [[supplier.contact_email, 'replacement@test.com']] }
  let(:service) { described_class.new(email_replacements) }

  describe '#replace' do
    before { service.replace }

    it 'will update the supplier contact email' do
      supplier.reload
      supplier_detail.reload

      expect(supplier.contact_email).to eq('replacement@test.com')
      expect(supplier_detail.contact_email).to eq('replacement@test.com')
    end
  end
end
