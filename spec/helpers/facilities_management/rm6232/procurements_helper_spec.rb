require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::ProcurementsHelper, type: :helper do
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
    let(:result) { helper.journey_step_url_former(journey_slug: journey_slug, annual_contract_value: annual_contract_value, region_codes: region_codes, service_codes: service_codes) }

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

      context 'when the annual contract value is nil' do
        let(:annual_contract_value) { nil }

        it 'returns the correct URL without the annual contract value' do
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

  describe '.link_url' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements) }
    let(:result) { helper.link_url(section) }

    before { @procurement = procurement }

    context 'when the section is contract_name' do
      let(:section) { 'contract_name' }

      it 'returns the edit details link' do
        expect(result).to eq "/facilities-management/RM6232/procurements/#{procurement.id}/procurement-details/contract-name/edit"
      end
    end

    context 'when the section is annual_contract_value' do
      let(:section) { 'annual_contract_value' }

      it 'returns the edit details link' do
        expect(result).to eq "/facilities-management/RM6232/procurements/#{procurement.id}/procurement-details/annual-contract-value/edit"
      end
    end

    context 'when the section is tupe' do
      let(:section) { 'tupe' }

      it 'returns the edit details link' do
        expect(result).to eq "/facilities-management/RM6232/procurements/#{procurement.id}/procurement-details/tupe/edit"
      end
    end

    context 'when the section is contract_period' do
      let(:section) { 'contract_period' }

      it 'returns the show details link' do
        expect(result).to eq "/facilities-management/RM6232/procurements/#{procurement.id}/procurement-details/contract-period"
      end
    end

    context 'when the section is services' do
      let(:section) { 'services' }

      it 'returns the show details link' do
        expect(result).to eq "/facilities-management/RM6232/procurements/#{procurement.id}/procurement-details/services"
      end
    end

    context 'when the section is buildings' do
      let(:section) { 'buildings' }

      it 'returns the show details link' do
        expect(result).to eq "/facilities-management/RM6232/procurements/#{procurement.id}/procurement-details/buildings"
      end
    end

    context 'when the section is buildings_and_services' do
      let(:section) { 'buildings_and_services' }

      it 'returns the show details link' do
        expect(result).to eq "/facilities-management/RM6232/procurements/#{procurement.id}/procurement-details/buildings-and-services"
      end
    end
  end

  describe '.section_has_error?' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements) }

    before { @procurement = procurement }

    context 'when there are no errors' do
      it 'returns false' do
        expect(helper.section_has_error?('buildings_and_services')).to be false
      end
    end

    context 'when there are errors' do
      before { procurement.errors.add(:base, :buildings_incomplete) }

      context 'and they are not on the section' do
        it 'returns false' do
          expect(helper.section_has_error?('buildings_and_services')).to be false
        end
      end

      context 'and they are on the section' do
        it 'returns true' do
          expect(helper.section_has_error?('buildings')).to be true
        end
      end
    end

    context 'when there are errors on contract period' do
      before { procurement.errors.add(:base, :initial_call_off_period_in_past) }

      it 'returns true' do
        expect(helper.section_has_error?('contract_period')).to be true
      end
    end
  end

  describe '.requirements_errors_list' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements) }

    before do
      incomplete_sections.each { |section| procurement.errors.add(:base, section) }
      @procurement = procurement
    end

    context 'when all sections are incomplete' do
      let(:incomplete_sections) { %i[tupe_incomplete contract_period_incomplete services_incomplete buildings_incomplete buildings_and_services_incomplete] }

      it 'returns the full list' do
        expect(helper.requirements_errors_list).to eq({
                                                        tupe_incomplete: '‘TUPE’ must be ‘COMPLETED’',
                                                        contract_period_incomplete: '‘Contract period’ must be ‘COMPLETED’',
                                                        services_incomplete: '‘Services’ must be ‘COMPLETED’',
                                                        buildings_incomplete: '‘Buildings’ must be ‘COMPLETED’',
                                                        buildings_and_services_incomplete: '‘Assigning services to buildings’ must be ‘COMPLETED’'
                                                      })
      end
    end

    context 'when some sections are incomplete' do
      let(:incomplete_sections) { %i[services_incomplete buildings_incomplete buildings_and_services_incomplete] }

      it 'returns a partial list' do
        expect(helper.requirements_errors_list).to eq({
                                                        services_incomplete: '‘Services’ must be ‘COMPLETED’',
                                                        buildings_incomplete: '‘Buildings’ must be ‘COMPLETED’',
                                                        buildings_and_services_incomplete: '‘Assigning services to buildings’ must be ‘COMPLETED’'
                                                      })
      end
    end
  end
end
