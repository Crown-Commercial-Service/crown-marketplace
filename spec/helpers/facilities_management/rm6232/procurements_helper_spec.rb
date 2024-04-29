require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::ProcurementsHelper do
  describe '.page_subtitle' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_what_happens_next, contract_name: 'Noah of colony 4', contract_number: 'RM6232-123456-2022') }

    before { @procurement = procurement }

    it 'returns the subtitle in the correct format' do
      expect(helper.page_subtitle).to eq 'Noah of colony 4 - RM6232-123456-2022'
    end
  end

  describe '.journey_step_url_former' do
    let(:service_codes) { ['E.1', 'F.1', 'G.1'] }
    let(:region_codes) { ['UKI3', 'UKI4'] }
    let(:annual_contract_value) { 500_000 }
    let(:result) { helper.journey_step_url_former(journey_slug:, annual_contract_value:, region_codes:, service_codes:) }

    context 'when the journey_slug is choose-services' do
      let(:journey_slug) { 'choose-services' }

      it 'returns the correct URL' do
        expect(result).to eq '/facilities-management/RM6232/choose-services?annual_contract_value=500000&region_codes%5B%5D=UKI3&region_codes%5B%5D=UKI4&service_codes%5B%5D=E.1&service_codes%5B%5D=F.1&service_codes%5B%5D=G.1'
      end

      context 'when the service codes are empty' do
        let(:service_codes) { [] }

        it 'returns the correct URL without service codes' do
          expect(result).to eq '/facilities-management/RM6232/choose-services?annual_contract_value=500000&region_codes%5B%5D=UKI3&region_codes%5B%5D=UKI4'
        end
      end

      context 'when the region codes are empty' do
        let(:region_codes) { [] }

        it 'returns the correct URL without region codes' do
          expect(result).to eq '/facilities-management/RM6232/choose-services?annual_contract_value=500000&service_codes%5B%5D=E.1&service_codes%5B%5D=F.1&service_codes%5B%5D=G.1'
        end
      end

      context 'when the annual contract cost is nil' do
        let(:annual_contract_value) { nil }

        it 'returns the correct URL without the annual contract cost' do
          expect(result).to eq '/facilities-management/RM6232/choose-services?region_codes%5B%5D=UKI3&region_codes%5B%5D=UKI4&service_codes%5B%5D=E.1&service_codes%5B%5D=F.1&service_codes%5B%5D=G.1'
        end
      end
    end

    context 'when the journey_slug is choose-locations' do
      let(:journey_slug) { 'choose-locations' }

      it 'returns the correct URL' do
        expect(result).to eq '/facilities-management/RM6232/choose-locations?annual_contract_value=500000&region_codes%5B%5D=UKI3&region_codes%5B%5D=UKI4&service_codes%5B%5D=E.1&service_codes%5B%5D=F.1&service_codes%5B%5D=G.1'
      end
    end

    context 'when the journey_slug is annual-contract-value' do
      let(:journey_slug) { 'annual-contract-value' }

      it 'returns the correct URL' do
        expect(result).to eq '/facilities-management/RM6232/annual-contract-value?annual_contract_value=500000&region_codes%5B%5D=UKI3&region_codes%5B%5D=UKI4&service_codes%5B%5D=E.1&service_codes%5B%5D=F.1&service_codes%5B%5D=G.1'
      end
    end
  end
end
