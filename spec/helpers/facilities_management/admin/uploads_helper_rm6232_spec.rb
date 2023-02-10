require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::UploadsHelper do
  describe 'get_admin_upload_error_details' do
    let(:error_details) { helper.get_admin_upload_error_details(error, details) }

    before { helper.params[:framework] = 'RM6232' }

    context 'when the error is supplier_missing_details' do
      let(:error) { :supplier_missing_details }
      let(:details) { ['Abernathy and Sons', 'Wolf-Wiza'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers do not have any details: <ul class="govuk-list govuk-list--bullet"><li>Abernathy and Sons</li><li>Wolf-Wiza</li></ul> Make sure all the suppliers are present in the \'Supplier details\' spreadsheet'
      end
    end

    context 'when the error is supplier_missing_lot_data' do
      let(:error) { :supplier_missing_lot_data }
      let(:details) { ['Abernathy and Sons', 'Wolf-Wiza', 'Bode and Sons'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers do not offer any services or regions: <ul class="govuk-list govuk-list--bullet"><li>Abernathy and Sons</li><li>Wolf-Wiza</li><li>Bode and Sons</li></ul> Make sure all the suppliers have the correct name and DUNS number'
      end
    end

    context 'when the error is supplier_missing_regions' do
      let(:error) { :supplier_missing_regions }
      let(:details) { ['Bode and Sons'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers do not offer services in any regions: <ul class="govuk-list govuk-list--bullet"><li>Bode and Sons</li></ul> Make sure all the suppliers have the correct name and DUNS number'
      end
    end

    context 'when the error is supplier_missing_services' do
      let(:error) { :supplier_missing_services }
      let(:details) { ['Ullrich, Ratke and Botsford', 'Bogan-Koch', 'Treutel LLC'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers do not offer any services: <ul class="govuk-list govuk-list--bullet"><li>Ullrich, Ratke and Botsford</li><li>Bogan-Koch</li><li>Treutel LLC</li></ul> Make sure all the suppliers have the correct name and DUNS number'
      end
    end

    context 'when the error is supplier_regions_has_empty_sheets' do
      let(:error) { :supplier_regions_has_empty_sheets }
      let(:details) { ['Bogan-Koch'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following sheets have no data: <ul class="govuk-list govuk-list--bullet"><li>Bogan-Koch</li></ul> Make sure all sheets for \'Supplier regions\' have been filled in'
      end
    end

    context 'when the error is supplier_regions_has_incorrect_headers' do
      let(:error) { :supplier_regions_has_incorrect_headers }
      let(:details) { ['Shields, Ratke and Parisian', 'Ullrich, Ratke and Botsford'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following sheets have incorrect column headers: <ul class="govuk-list govuk-list--bullet"><li>Shields, Ratke and Parisian</li><li>Ullrich, Ratke and Botsford</li></ul> Make sure all sheets for \'Supplier regions\' have the expected region codes. You can find these in the spreadsheet template.'
      end
    end

    context 'when the error is supplier_services_has_empty_sheets' do
      let(:error) { :supplier_services_has_empty_sheets }
      let(:details) { ['Cartwright and Sons', 'Shields, Ratke and Parisian'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following sheets have no data: <ul class="govuk-list govuk-list--bullet"><li>Cartwright and Sons</li><li>Shields, Ratke and Parisian</li></ul> Make sure all sheets for \'Supplier services\' have been filled in'
      end
    end

    context 'when the error is supplier_services_has_incorrect_headers' do
      let(:error) { :supplier_services_has_incorrect_headers }
      let(:details) { ['Collier Group'] }

      it 'returns the correct error message' do
        expect(error_details).to eq "The following sheets have incorrect row headers: <ul class=\"govuk-list govuk-list--bullet\"><li>Collier Group</li></ul> Make sure all sheets for 'Supplier services' have the expected services codes. You can find these in the spreadsheet template."
      end
    end
  end
end
