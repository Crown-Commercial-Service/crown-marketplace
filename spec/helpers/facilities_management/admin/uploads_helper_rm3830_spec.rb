require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::UploadsHelper do
  describe 'get_admin_upload_error_details' do
    let(:error_details) { helper.get_admin_upload_error_details(error, details) }

    before { helper.params[:framework] = 'RM3830' }

    context 'when the error is discounts_less_than_or_equal_to' do
      let(:error) { :discounts_less_than_or_equal_to }
      let(:details) { ['Abernathy and Sons', 'Wolf-Wiza'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers have discounts that are greater than 100%: <ul class="govuk-list govuk-list--bullet"><li>Abernathy and Sons</li><li>Wolf-Wiza</li></ul> Make sure all discounts are 100% or less'
      end
    end

    context 'when the error is discounts_more_than_max_decimals' do
      let(:error) { :discounts_more_than_max_decimals }
      let(:details) { ['Abernathy and Sons', 'Wolf-Wiza', 'Bode and Sons'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers have discounts with more than 20 decimal places: <ul class="govuk-list govuk-list--bullet"><li>Abernathy and Sons</li><li>Wolf-Wiza</li><li>Bode and Sons</li></ul> Make sure all discounts have no more than 20 decimal places'
      end
    end

    context 'when the error is discounts_not_a_number' do
      let(:error) { :discounts_not_a_number }
      let(:details) { ['Bode and Sons'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers have discounts that are not numbers: <ul class="govuk-list govuk-list--bullet"><li>Bode and Sons</li></ul> Make sure all discounts are numbers, for example 0.26 or 1'
      end
    end

    context 'when the error is prices_blank' do
      let(:error) { :prices_blank }
      let(:details) { ['Ullrich, Ratke and Botsford', 'Bogan-Koch', 'Treutel LLC'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers have blank prices: <ul class="govuk-list govuk-list--bullet"><li>Ullrich, Ratke and Botsford</li><li>Bogan-Koch</li><li>Treutel LLC</li></ul> Make sure all prices have been filled in for each service. If a supplier does not offer a service, remove that row from the spreadsheet'
      end
    end

    context 'when the error is prices_greater_than_or_equal_to' do
      let(:error) { :prices_greater_than_or_equal_to }
      let(:details) { ['Bogan-Koch'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers have prices that are less than 0: <ul class="govuk-list govuk-list--bullet"><li>Bogan-Koch</li></ul> Make sure all prices are greater than or equal to 0'
      end
    end

    context 'when the error is prices_less_than_or_equal_to' do
      let(:error) { :prices_less_than_or_equal_to }
      let(:details) { ['Shields, Ratke and Parisian', 'Ullrich, Ratke and Botsford'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers have prices for CAFM system and/or Helpdesk services that are greater than 100%: <ul class="govuk-list govuk-list--bullet"><li>Shields, Ratke and Parisian</li><li>Ullrich, Ratke and Botsford</li></ul> Make sure these prices are 100% or less'
      end
    end

    context 'when the error is prices_not_a_number' do
      let(:error) { :prices_not_a_number }
      let(:details) { ['Cartwright and Sons', 'Shields, Ratke and Parisian'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers have prices that are not numbers: <ul class="govuk-list govuk-list--bullet"><li>Cartwright and Sons</li><li>Shields, Ratke and Parisian</li></ul> Make sure all prices are numbers, for example 0.26 or 1'
      end
    end

    context 'when the error is variances_blank' do
      let(:error) { :variances_blank }
      let(:details) { ['Collier Group'] }

      it 'returns the correct error message' do
        expect(error_details).to eq "The following suppliers have 'Cleaning consumables per building' as blank: <ul class=\"govuk-list govuk-list--bullet\"><li>Collier Group</li></ul> Make sure 'Cleaning consumables per building' has been filled in for all suppliers"
      end
    end

    context 'when the error is variances_greater_than_or_equal_to' do
      let(:error) { :variances_greater_than_or_equal_to }
      let(:details) { ['Schmeler-Leuschke', 'Collier Group'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers have variances that are less than 0: <ul class="govuk-list govuk-list--bullet"><li>Schmeler-Leuschke</li><li>Collier Group</li></ul> Make sure all variances are greater than or equal to 0'
      end
    end

    context 'when the error is variances_less_than_or_equal_to' do
      let(:error) { :variances_less_than_or_equal_to }
      let(:details) { ['Schmeler-Leuschke', 'Dare, Heaney and Kozey', 'Rowe, Hessel and Heller'] }

      it 'returns the correct error message' do
        expect(error_details).to eq "The following suppliers have variances that are greater than 100%: <ul class=\"govuk-list govuk-list--bullet\"><li>Schmeler-Leuschke</li><li>Dare, Heaney and Kozey</li><li>Rowe, Hessel and Heller</li></ul> Make sure all variances are 100% or less (excluding 'Cleaning consumables per building')"
      end
    end

    context 'when the error is variances_more_than_max_decimals' do
      let(:error) { :variances_more_than_max_decimals }
      let(:details) { ['Dare, Heaney and Kozey'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers have variances with more than 20 decimal places: <ul class="govuk-list govuk-list--bullet"><li>Dare, Heaney and Kozey</li></ul> Make sure all variances have no more than 20 decimal places (excluding \'Cleaning consumables per building\')'
      end
    end

    context 'when the error is variances_not_a_number' do
      let(:error) { :variances_not_a_number }
      let(:details) { ['Dickinson-Abbott', 'O\'Keefe-Mitchell'] }

      it 'returns the correct error message' do
        expect(error_details).to eq 'The following suppliers have variances that are not numbers: <ul class="govuk-list govuk-list--bullet"><li>Dickinson-Abbott</li><li>O&#39;Keefe-Mitchell</li></ul> Make sure all variances are numbers, for example 0.26 or 1'
      end
    end
  end
end
