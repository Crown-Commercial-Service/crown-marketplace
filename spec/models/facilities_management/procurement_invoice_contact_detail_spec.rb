require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementInvoiceContactDetail, type: :model do
  let(:procurement_invoice_contact_detail) { create(:facilities_management_procurement_invoice_contact_detail) }

  describe 'associations' do
    it { is_expected.to belong_to(:procurement).class_name('FacilitiesManagement::Procurement') }
  end
end
