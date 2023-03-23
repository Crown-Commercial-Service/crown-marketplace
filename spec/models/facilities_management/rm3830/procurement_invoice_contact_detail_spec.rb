require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementInvoiceContactDetail do
  let(:procurement_invoice_contact_detail) { create(:facilities_management_rm3830_procurement_invoice_contact_detail) }

  describe 'associations' do
    it { is_expected.to belong_to(:procurement).class_name('FacilitiesManagement::RM3830::Procurement') }
  end
end
