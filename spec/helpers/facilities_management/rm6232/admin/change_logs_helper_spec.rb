require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::ChangeLogsHelper do
  describe '.show_page_title' do
    let(:result) { helper.show_page_title }

    before { @change_log = change_log }

    context 'when the true_change_type is details' do
      let(:change_log) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_details) }

      it "returns 'Changes to supplier details'" do
        expect(result).to eq('Changes to supplier details')
      end
    end

    context 'when the true_change_type is region_codes' do
      let(:change_log) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_region_lot_data) }

      it "returns 'Changes to supplier regions'" do
        expect(result).to eq('Changes to supplier regions')
      end
    end

    context 'when the true_change_type is service_codes' do
      let(:change_log) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_service_lot_data) }

      it "returns 'Changes to supplier services'" do
        expect(result).to eq('Changes to supplier services')
      end
    end

    context 'when the true_change_type is upload' do
      let(:change_log) { FacilitiesManagement::RM6232::Admin::SupplierData.latest_data }

      it "returns 'Supplier data upload'" do
        expect(result).to eq('Supplier data upload')
      end
    end
  end

  describe '.item_names' do
    let(:result) { helper.item_names(codes) }

    before { @change_log = change_log }

    context 'when passing in region codes' do
      let(:change_log) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_region_lot_data) }
      let(:codes) { %w[UKD1 UKC1 UKM26] }

      it 'returns the region names with the region codes sorted' do
        expect(result).to eq(
          [
            'Tees Valley and Durham (UKC1)',
            'Cumbria (UKD1)',
            'Falkirk (UKM26)'
          ]
        )
      end
    end

    context 'when passing in service codes' do
      let(:change_log) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_service_lot_data) }
      let(:codes) { %w[F.4 E.12 E.5 F.5] }

      it 'returns the service codes with the service name sorted' do
        expect(result).to eq(
          [
            'E.5 Lifts, hoists and conveyance systems maintenance',
            'E.12 Standby power system maintenance',
            'F.4 Portable Appliance Testing',
            'F.5 Miscellaneous Surveys, Audits and Testing Services'
          ]
        )
      end
    end
  end

  describe '.get_attribute_value' do
    let(:result) { helper.get_attribute_value(attribute, value) }

    context "when the attribute is 'active'" do
      let(:attribute) { 'active' }

      context 'and the value is nil' do
        let(:value) { nil }

        it 'returns the active tag' do
          expect(result).to eq '<strong class="govuk-tag govuk-tag">ACTIVE</strong>'
        end
      end

      context 'and the value is true' do
        let(:value) { true }

        it 'returns the active tag' do
          expect(result).to eq '<strong class="govuk-tag govuk-tag">ACTIVE</strong>'
        end
      end

      context 'and the value is false' do
        let(:value) { false }

        it 'returns the inactive tag' do
          expect(result).to eq '<strong class="govuk-tag govuk-tag--red">INACTIVE</strong>'
        end
      end
    end

    context "when the attribute is not 'active'" do
      let(:attribute) { 'supplier_name' }
      let(:value) { 'Fifi' }

      it 'returns the value' do
        expect(result).to eq value
      end
    end
  end
end
