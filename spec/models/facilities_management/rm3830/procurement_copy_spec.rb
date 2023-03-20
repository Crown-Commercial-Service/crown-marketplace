require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Procurement do
  subject(:procurement) { create(:facilities_management_rm3830_procurement_with_contact_details, user:) }

  let(:user) { create(:user) }
  let(:security_policy_document_file) { Tempfile.new(['security_policy_document_file', '.txt']) }
  let(:security_policy_document_file_path) { fixture_file_upload(security_policy_document_file.path, 'text/plain') }

  before { procurement.update(security_policy_document_file: security_policy_document_file_path) }

  after { security_policy_document_file.unlink }

  describe '#create_procurement_copy' do
    let(:procurement_copy) { procurement.create_procurement_copy }

    context 'when a copy has been made of a procurement with full use of contact details' do
      context 'when comparing attributes' do
        it 'will not have a contract name' do
          expect(procurement_copy.contract_name).to be_nil
        end

        it 'will have an aasm_state of details_search' do
          expect(procurement_copy.aasm_state).to eq 'detailed_search'
        end

        it 'will have a da_journey_state of pricing' do
          expect(procurement_copy.da_journey_state).to eq 'pricing'
        end

        it 'will have the same attributes as the procurement' do
          procurement_attributes = procurement.attributes.except('id', 'aasm_state', 'created_at', 'updated_at', 'contract_name', 'da_journey_state', 'lot_number', 'lot_number_selected_by_customer')
          procurement_copy_attributes = procurement_copy.attributes.except('id', 'aasm_state', 'created_at', 'updated_at', 'contract_name', 'da_journey_state', 'lot_number', 'lot_number_selected_by_customer')
          expect(procurement_copy_attributes).to eq procurement_attributes
        end
      end

      context 'when considering optional call of extensions' do
        it 'will have the extension periods' do
          expect(procurement_copy.call_off_extensions.size).to eq 4
        end

        it 'will have the right period for extension 1' do
          expect(procurement_copy.call_off_extensions.select { |call_off_extension| call_off_extension.extension == 0 }.first.period).to eq 0.years + 1.month
        end

        it 'will have the right period for extension 2' do
          expect(procurement_copy.call_off_extensions.select { |call_off_extension| call_off_extension.extension == 1 }.first.period).to eq 1.year + 2.months
        end

        it 'will have the right period for extension 3' do
          expect(procurement_copy.call_off_extensions.select { |call_off_extension| call_off_extension.extension == 2 }.first.period).to eq 2.years + 3.months
        end

        it 'will have the right period for extension 4' do
          expect(procurement_copy.call_off_extensions.select { |call_off_extension| call_off_extension.extension == 3 }.first.period).to eq 3.years + 0.months
        end
      end

      context 'when considering procurement buildings' do
        it 'will have procurement buildings' do
          expect(procurement_copy.procurement_buildings).not_to be_empty
        end

        it 'will have the same procurement buildings' do
          procurement_buildings = procurement.procurement_buildings.map(&:name)
          procurement_copy_building = procurement_copy.procurement_buildings.map(&:name)
          expect(procurement_buildings).to eq procurement_copy_building
        end
      end

      context 'when considering pension funds' do
        it 'will have procurement pension funds' do
          expect(procurement_copy.procurement_pension_funds).not_to be_empty
        end

        it 'will have the same pension fund attributes as the origional procurement' do
          procurement_pension_funds = procurement.procurement_pension_funds.map { |pension_fund| { name: pension_fund.name, percentage: pension_fund.percentage } }
          procurement_copy_pension_funds = procurement_copy.procurement_pension_funds.map { |pension_fund| { name: pension_fund.name, percentage: pension_fund.percentage } }
          expect(procurement_copy_pension_funds).to eq procurement_pension_funds
        end
      end

      context 'when considering contact details' do
        it 'will have contact details' do
          expect(procurement_copy.invoice_contact_detail).not_to be_nil
          expect(procurement_copy.authorised_contact_detail).not_to be_nil
          expect(procurement_copy.notices_contact_detail).not_to be_nil
        end

        it 'will have the same invoice contact detail' do
          procurement_invoice_contact_detail = procurement.invoice_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_rm3830_procurement_id')
          procurement_copy_invoice_contact_detail = procurement_copy.invoice_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_rm3830_procurement_id')
          expect(procurement_copy_invoice_contact_detail).to eq procurement_invoice_contact_detail
        end

        it 'will have the same authorised contact detail' do
          procurement_authorised_contact_detail = procurement.authorised_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_rm3830_procurement_id')
          procurement_copy_authorised_contact_detail = procurement_copy.authorised_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_rm3830_procurement_id')
          expect(procurement_copy_authorised_contact_detail).to eq procurement_authorised_contact_detail
        end

        it 'will have the same notices contact detail' do
          procurement_notices_contact_detail = procurement.notices_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_rm3830_procurement_id')
          procurement_copy_notices_contact_detail = procurement_copy.notices_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_rm3830_procurement_id')
          expect(procurement_copy_notices_contact_detail).to eq procurement_notices_contact_detail
        end
      end

      it 'will not have procurement suppliers' do
        expect(procurement_copy.procurement_suppliers).to be_empty
      end

      context 'when considering security policy document file' do
        it 'will have a file' do
          expect(procurement_copy.security_policy_document_file).to be_attached
        end

        it 'will have the same file' do
          expect(procurement_copy.security_policy_document_file.blob).to eq procurement.security_policy_document_file.blob
        end
      end
    end

    context 'when considering lifts' do
      let(:procurement) { create(:facilities_management_rm3830_procurement_with_lifts, user:) }

      it 'will have the same lift data' do
        procurement_lift_data = procurement.procurement_buildings.first.procurement_building_services.first.lift_data
        procurement_copy_lift_data = procurement_copy.procurement_buildings.first.procurement_building_services.first.lift_data

        expect(procurement_copy_lift_data).to eq procurement_lift_data
      end
    end

    context 'when a copy has been made of a procurement without full use of contact details' do
      let(:second_procurement) { create(:facilities_management_rm3830_procurement, user:) }
      let(:second_procurement_copy) { second_procurement.create_procurement_copy }

      it 'will have the same attributes as the procurement' do
        procurement_attributes = second_procurement.attributes.except('id', 'aasm_state', 'created_at', 'updated_at', 'contract_name', 'da_journey_state', 'lot_number', 'lot_number_selected_by_customer')
        procurement_copy_attributes = second_procurement_copy.attributes.except('id', 'aasm_state', 'created_at', 'updated_at', 'contract_name', 'da_journey_state', 'lot_number', 'lot_number_selected_by_customer')
        expect(procurement_copy_attributes).to eq procurement_attributes
      end

      it 'will not have contact details' do
        expect(second_procurement_copy.invoice_contact_detail).to be_nil
        expect(second_procurement_copy.authorised_contact_detail).to be_nil
        expect(second_procurement_copy.notices_contact_detail).to be_nil
      end

      it 'will not have pension funds' do
        expect(second_procurement_copy.procurement_pension_funds).to be_empty
      end

      it 'will have not have a security policy document file' do
        expect(second_procurement_copy.security_policy_document_file.attachment).to be_nil
      end
    end
  end
end
