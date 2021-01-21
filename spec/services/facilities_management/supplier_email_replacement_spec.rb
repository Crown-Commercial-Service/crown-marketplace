require 'rails_helper'

RSpec.describe FacilitiesManagement::SupplierEmailReplacement do
  let(:supplier) { create(:facilities_management_supplier_detail) }
  let(:email_replacements) { [[supplier.contact_email, 'replacement@test.com']] }
  let(:service) { described_class.new(email_replacements) }

  describe '#replace' do
    before { service.replace }

    it 'will update the supplier contact email' do
      supplier.reload

      expect(supplier.contact_email).to eq('replacement@test.com')
    end
  end
end
