require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementsHelper do
  describe '.journey_step_url_former' do
    let(:service_codes) { ['C.1', 'D.1', 'E.1', 'F.1', 'G.1'] }
    let(:result) { helper.journey_step_url_former(journey_step: journey_step, framework: 'RM3830', region_codes: region_codes, service_codes: service_codes) }

    context 'when there are service codes' do
      let(:journey_step) { 'services' }
      let(:region_codes) { nil }

      it 'when the previous journey_step is services' do
        expect(result).to eq '/facilities-management/RM3830/choose-services?service_codes%5B%5D=C.1&service_codes%5B%5D=D.1&service_codes%5B%5D=E.1&service_codes%5B%5D=F.1&service_codes%5B%5D=G.1'
      end
    end

    context 'when the previous journey_step is locations' do
      let(:journey_step) { 'locations' }
      let(:region_codes) { ['UKI3', 'UKI4', 'UKI5', 'UKI6', 'UKI7'] }

      it 'returns the right link' do
        expect(result).to eq '/facilities-management/RM3830/choose-locations?region_codes%5B%5D=UKI3&region_codes%5B%5D=UKI4&region_codes%5B%5D=UKI5&region_codes%5B%5D=UKI6&region_codes%5B%5D=UKI7&service_codes%5B%5D=C.1&service_codes%5B%5D=D.1&service_codes%5B%5D=E.1&service_codes%5B%5D=F.1&service_codes%5B%5D=G.1'
      end
    end
  end

  describe '.procurement_state' do
    let(:result) { helper.procurement_state(procurement_state) }

    context 'when the procurement state is quick_search' do
      let(:procurement_state) { 'quick_search' }

      it "returns 'Quick view'" do
        expect(result).to eq 'Quick view'
      end
    end

    context 'when the procurement state is detailed_search' do
      let(:procurement_state) { 'detailed_search' }

      it "returns 'Entering requirements'" do
        expect(result).to eq 'Entering requirements'
      end
    end

    context 'when the procurement state is detailed_search_bulk_upload' do
      let(:procurement_state) { 'detailed_search_bulk_upload' }

      it "returns 'Entering requirements'" do
        expect(result).to eq 'Entering requirements'
      end
    end

    context 'when the procurement state is choose_contract_value' do
      let(:procurement_state) { 'choose_contract_value' }

      it "returns 'Choose contract value'" do
        expect(result).to eq 'Choose contract value'
      end
    end

    context 'when the procurement state is results' do
      let(:procurement_state) { 'results' }

      it "returns 'Results'" do
        expect(result).to eq 'Results'
      end
    end

    context 'when the procurement state is da_draft' do
      let(:procurement_state) { 'da_draft' }

      it "returns 'DA draft'" do
        expect(result).to eq 'DA draft'
      end
    end

    context 'when the procurement state is direct_award' do
      let(:procurement_state) { 'direct_award' }

      it "returns 'Direct award'" do
        expect(result).to eq 'Direct award'
      end
    end

    context 'when the procurement state is further_competition' do
      let(:procurement_state) { 'further_competition' }

      it "returns 'Further competition'" do
        expect(result).to eq 'Further competition'
      end
    end

    context 'when the procurement state is closed' do
      let(:procurement_state) { 'closed' }

      it "returns 'closed'" do
        expect(result).to eq 'closed'
      end
    end
  end

  describe '.sort_by_pension_fund_created_at' do
    let(:procurement) { create(:facilities_management_rm3830_procurement) }
    let(:pension_fund1) { create(:facilities_management_rm3830_procurement_pension_fund, created_at: 1.day.ago, procurement: procurement) }
    let(:pension_fund2) { create(:facilities_management_rm3830_procurement_pension_fund, created_at: 4.days.ago, procurement: procurement) }
    let(:pension_fund3) { create(:facilities_management_rm3830_procurement_pension_fund, created_at: 3.days.ago, procurement: procurement) }
    let(:pension_fund4) { create(:facilities_management_rm3830_procurement_pension_fund, created_at: 2.days.ago, procurement: procurement) }

    before do
      pension_fund1
      pension_fund2
      pension_fund3
      pension_fund4
      @procurement = procurement
    end

    context 'when all the pension funds have a created_at' do
      it 'sorts all the pensions by created at' do
        expect(helper.sort_by_pension_fund_created_at).to eq [pension_fund2, pension_fund3, pension_fund4, pension_fund1]
      end
    end

    context 'when a pension has nil for created_at' do
      let(:pension_fund3) { create(:facilities_management_rm3830_procurement_pension_fund, created_at: nil, procurement: procurement) }

      it 'sorts all the pension with pension_fund3 at the end' do
        expect(helper.sort_by_pension_fund_created_at).to eq [pension_fund2, pension_fund4, pension_fund1, pension_fund3]
      end
    end
  end

  describe '.continue_button_text' do
    before { helper.params[:step] = procurement_step }

    context 'when the step is contract_name' do
      let(:procurement_step) { 'contract_name' }

      it 'returns save_and_return' do
        expect(helper.continue_button_text).to eq 'save_and_return'
      end
    end

    context 'when the step is estimated_annual_cost' do
      let(:procurement_step) { 'estimated_annual_cost' }

      it 'returns save_and_return' do
        expect(helper.continue_button_text).to eq 'save_and_return'
      end
    end

    context 'when the step is tupe' do
      let(:procurement_step) { 'tupe' }

      it 'returns save_and_return' do
        expect(helper.continue_button_text).to eq 'save_and_return'
      end
    end

    context 'when the step is contract_period' do
      let(:procurement_step) { 'contract_period' }

      it 'returns save_and_continue' do
        expect(helper.continue_button_text).to eq 'save_and_continue'
      end
    end

    context 'when the step is services' do
      let(:procurement_step) { 'services' }

      it 'returns save_and_continue' do
        expect(helper.continue_button_text).to eq 'save_and_continue'
      end
    end

    context 'when the step is buildings' do
      let(:procurement_step) { 'buildings' }

      it 'returns save_and_continue' do
        expect(helper.continue_button_text).to eq 'save_and_continue'
      end
    end

    context 'when the step is buildings_and_services' do
      let(:procurement_step) { 'buildings_and_services' }

      it 'returns save_and_continue' do
        expect(helper.continue_button_text).to eq 'save_and_continue'
      end
    end
  end

  describe '.requires_back_link?' do
    before { helper.params[:step] = procurement_step }

    context 'when the step is contract_name' do
      let(:procurement_step) { 'contract_name' }

      it 'returns save_and_return' do
        expect(helper.requires_back_link?).to be true
      end
    end

    context 'when the step is estimated_annual_cost' do
      let(:procurement_step) { 'estimated_annual_cost' }

      it 'returns save_and_return' do
        expect(helper.requires_back_link?).to be true
      end
    end

    context 'when the step is tupe' do
      let(:procurement_step) { 'tupe' }

      it 'returns save_and_return' do
        expect(helper.requires_back_link?).to be true
      end
    end

    context 'when the step is contract_period' do
      let(:procurement_step) { 'contract_period' }

      it 'returns save_and_continue' do
        expect(helper.requires_back_link?).to be false
      end
    end

    context 'when the step is services' do
      let(:procurement_step) { 'services' }

      it 'returns save_and_continue' do
        expect(helper.requires_back_link?).to be false
      end
    end

    context 'when the step is buildings' do
      let(:procurement_step) { 'buildings' }

      it 'returns save_and_continue' do
        expect(helper.requires_back_link?).to be true
      end
    end

    context 'when the step is buildings_and_services' do
      let(:procurement_step) { 'buildings_and_services' }

      it 'returns save_and_continue' do
        expect(helper.requires_back_link?).to be false
      end
    end
  end

  describe '.requirements_errors_list' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }

    before do
      incomplete_sections.each { |section| procurement.errors.add(:base, section) }
      @procurement = procurement
    end

    context 'when all sections are incomplete' do
      let(:incomplete_sections) { %i[tupe_incomplete estimated_annual_cost_incomplete contract_period_incomplete services_incomplete buildings_incomplete buildings_and_services_incomplete service_requirements_incomplete] }

      it 'returns the full list' do
        expect(helper.requirements_errors_list).to eq({
                                                        tupe_incomplete: '‘TUPE’ must be ‘COMPLETED’',
                                                        estimated_annual_cost_incomplete: '‘Estimated annual cost’ must be ‘COMPLETED’',
                                                        contract_period_incomplete: '‘Contract period’ must be ‘COMPLETED’',
                                                        services_incomplete: '‘Services’ must be ‘COMPLETED’',
                                                        buildings_incomplete: '‘Buildings’ must be ‘COMPLETED’',
                                                        buildings_and_services_incomplete: '‘Assigning services to buildings’ must be ‘COMPLETED’',
                                                        service_requirements_incomplete: '‘Service requirements’ must be ‘COMPLETED’'
                                                      })
      end
    end

    context 'when some sections are incomplete' do
      let(:incomplete_sections) { %i[services_incomplete buildings_incomplete buildings_and_services_incomplete service_requirements_incomplete] }

      it 'returns a partial list' do
        expect(helper.requirements_errors_list).to eq({
                                                        services_incomplete: '‘Services’ must be ‘COMPLETED’',
                                                        buildings_incomplete: '‘Buildings’ must be ‘COMPLETED’',
                                                        buildings_and_services_incomplete: '‘Assigning services to buildings’ must be ‘COMPLETED’',
                                                        service_requirements_incomplete: '‘Service requirements’ must be ‘COMPLETED’'
                                                      })
      end
    end
  end

  describe '.section_has_error?' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }

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

  describe '.link_url' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }
    let(:result) { helper.link_url(section) }

    before { @procurement = procurement }

    context 'when the section is contract_name' do
      let(:section) { 'contract_name' }

      it 'returns the edit link' do
        expect(result).to eq "/facilities-management/RM3830/procurements/#{procurement.id}/procurement-details/contract-name/edit"
      end
    end

    context 'when the section is estimated_annual_cost' do
      let(:section) { 'estimated_annual_cost' }

      it 'returns the edit link' do
        expect(result).to eq "/facilities-management/RM3830/procurements/#{procurement.id}/procurement-details/estimated-annual-cost/edit"
      end
    end

    context 'when the section is tupe' do
      let(:section) { 'tupe' }

      it 'returns the edit link' do
        expect(result).to eq "/facilities-management/RM3830/procurements/#{procurement.id}/procurement-details/tupe/edit"
      end
    end

    context 'when the section is contract_period' do
      let(:section) { 'contract_period' }

      it 'returns the summary link' do
        expect(result).to eq "/facilities-management/RM3830/procurements/#{procurement.id}/procurement-details/contract-period"
      end
    end

    context 'when the section is services' do
      let(:section) { 'services' }

      it 'returns the summary link' do
        expect(result).to eq "/facilities-management/RM3830/procurements/#{procurement.id}/procurement-details/services"
      end
    end

    context 'when the section is buildings' do
      let(:section) { 'buildings' }

      it 'returns the summary link' do
        expect(result).to eq "/facilities-management/RM3830/procurements/#{procurement.id}/procurement-details/buildings"
      end
    end

    context 'when the section is buildings_and_services' do
      let(:section) { 'buildings_and_services' }

      it 'returns the summary link' do
        expect(result).to eq "/facilities-management/RM3830/procurements/#{procurement.id}/procurement-details/buildings-and-services"
      end
    end

    context 'when the section is service_requirements' do
      let(:section) { 'service_requirements' }

      it 'returns the summary link' do
        expect(result).to eq "/facilities-management/RM3830/procurements/#{procurement.id}/procurement-details/service-requirements"
      end
    end
  end

  describe '.work_packages_names' do
    let(:work_packages_names) { helper.work_packages_names }

    it 'has 135 work packages' do
      expect(work_packages_names.size).to eq 135
    end

    it 'includes the right work package names' do
      expect(work_packages_names['C.9']).to eq 'Planned / group re-lamping service'
      expect(work_packages_names['H.15']).to eq 'Portable washroom solutions'
      expect(work_packages_names['L.10']).to eq 'Housing and residential accommodation management'
    end
  end

  describe '.active_procurement_buildings' do
    let(:procurement_building1) { procurement.procurement_buildings.create(active: true, building: create(:facilities_management_building, building_name: 'Z building')) }
    let(:procurement_building2) { procurement.procurement_buildings.create(active: true, building: create(:facilities_management_building, building_name: 'L building')) }
    let(:procurement_building3) { procurement.procurement_buildings.create(active: true, building: create(:facilities_management_building, building_name: 'K building')) }
    let(:procurement_building4) { procurement.procurement_buildings.create(active: true, building: create(:facilities_management_building, building_name: 'T building')) }
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }

    before do
      procurement_building1
      procurement_building2
      procurement_building3
      procurement_building4
      @procurement = procurement
    end

    it 'returns the buildings sorted by building name' do
      expect(helper.active_procurement_buildings).to eq [procurement_building3, procurement_building2, procurement_building4, procurement_building1]
    end
  end

  describe '.number_of_suppliers' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_direct_award) }

    before { @procurement = procurement }

    it 'returns a count of 3' do
      expect(helper.number_of_suppliers).to eq 3
    end
  end

  describe '.procurement_services' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }

    before do
      procurement.procurement_buildings.create(active: true, service_codes: ['I.3', 'K.6'], building: create(:facilities_management_building))
      procurement.procurement_buildings.create(active: true, service_codes: ['G.16', 'K.6'], building: create(:facilities_management_building))
      procurement.procurement_buildings.create(active: true, service_codes: ['C.1', 'G.16'], building: create(:facilities_management_building))
      procurement.procurement_buildings.create(active: true, service_codes: ['C.1', 'I.3'], building: create(:facilities_management_building))
      @procurement = procurement
    end

    it 'returns the correct number of services' do
      expect(helper.procurement_services.size).to eq 4
    end

    it 'returns the correct services' do
      expect(helper.procurement_services).to eq ['Car park management and booking', 'Medical waste', 'Linen and laundry services', 'Mechanical and electrical engineering maintenance']
    end
  end

  describe '.lowest_supplier_price' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }

    before do
      create(:facilities_management_rm3830_procurement_supplier, procurement: procurement, direct_award_value: 2345)
      create(:facilities_management_rm3830_procurement_supplier, procurement: procurement, direct_award_value: 4567)
      create(:facilities_management_rm3830_procurement_supplier, procurement: procurement, direct_award_value: 1234)
      create(:facilities_management_rm3830_procurement_supplier, procurement: procurement, direct_award_value: 3456)
      @procurement = procurement
    end

    it 'returns 1234' do
      expect(helper.lowest_supplier_price).to eq 1234
    end
  end

  describe '.suppliers' do
    let(:procurement_supplier1) { create(:facilities_management_rm3830_procurement_supplier, procurement: procurement, direct_award_value: 2345) }
    let(:procurement_supplier2) { create(:facilities_management_rm3830_procurement_supplier, procurement: procurement, direct_award_value: 4567) }
    let(:procurement_supplier3) { create(:facilities_management_rm3830_procurement_supplier, procurement: procurement, direct_award_value: 1234) }
    let(:procurement_supplier4) { create(:facilities_management_rm3830_procurement_supplier, procurement: procurement, direct_award_value: 3456) }
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }

    before do
      procurement_supplier1
      procurement_supplier2
      procurement_supplier3
      procurement_supplier4
      @procurement = procurement
    end

    it 'returns the list of supplier names' do
      expect(helper.suppliers).to contain_exactly(procurement_supplier1.supplier_name, procurement_supplier2.supplier_name, procurement_supplier3.supplier_name, procurement_supplier4.supplier_name)
    end
  end

  describe '.unpriced_services' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }

    before do
      procurement.procurement_buildings.create(active: true, service_codes: ['C.5', 'D.3'], building: create(:facilities_management_building))
      procurement.procurement_buildings.create(active: true, service_codes: ['D.3', 'E.1'], building: create(:facilities_management_building))
      procurement.procurement_buildings.create(active: true, service_codes: ['E.1', 'F.7'], building: create(:facilities_management_building))
      procurement.procurement_buildings.create(active: true, service_codes: ['F.7', 'C.5'], building: create(:facilities_management_building))
      @procurement = procurement
    end

    it 'returns the correct number of services' do
      expect(helper.unpriced_services.size).to eq 2
    end

    it 'returns the correct services' do
      expect(helper.unpriced_services).to eq ['Professional snow & ice clearance', 'Outside catering']
    end
  end

  describe 'services and service_codes' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings, service_codes: ['C.7', 'F.4', 'M.1']) }

    before { @procurement = procurement }

    it 'returns the correct number of service codes' do
      expect(helper.service_codes.size).to eq 3
    end

    it 'returns the correct service codes' do
      expect(helper.service_codes).to eq ['C.7', 'F.4', 'M.1']
    end

    it 'returns the correct services' do
      expect(helper.services.map(&:name)).to eq ['Internal & external building fabric maintenance', 'Events and functions', 'CAFM system']
    end
  end

  describe 'regions and region_codes' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings, region_codes: ['UKF2', 'UKJ1', 'UKM23', 'UKN03']) }

    before { @procurement = procurement }

    it 'returns the correct number of region codes' do
      expect(helper.region_codes.size).to eq 4
    end

    it 'returns the correct region codes' do
      expect(helper.region_codes).to eq ['UKF2', 'UKJ1', 'UKM23', 'UKN03']
    end

    it 'returns the correct regions' do
      expect(helper.regions.map(&:name)).to eq ['Leicestershire, Rutland and Northamptonshire', 'Berkshire, Buckinghamshire and Oxfordshire', 'East Lothian and Midlothian', 'East of Northern Ireland (Antrim, Ards, Ballymena, Banbridge, Craigavon, Down, Larne)']
    end
  end

  describe 'methods relating to suppliers' do
    let(:service_codes) { FacilitiesManagement::RM3830::StaticData.work_packages.reject { |wp| ['A', 'B'].include? wp['work_package_code'] }.pluck('code') }
    let(:region_codes) { FacilitiesManagement::Region.all.reject { |region| region.code == 'OS01' }.map(&:code) }
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings, region_codes:, service_codes:) }

    before { @procurement = procurement }

    context 'when considering suppliers_lot1a' do
      it 'returns the correct number of suppliers' do
        expect(helper.suppliers_lot1a.size).to eq 9
      end

      it 'returns the correct suppliers' do
        expect(helper.suppliers_lot1a.pluck('name')).to eq ['Bogan-Koch', 'Dare, Heaney and Kozey', 'Dickinson-Abbott', 'Hirthe-Mills', 'Lebsack, Vandervort and Veum', 'Leffler-Strosin', 'Marvin, Kunde and Cartwright', "O'Keefe LLC", "O'Keefe-Mitchell"]
      end
    end

    context 'when considering suppliers_lot1b' do
      it 'returns the correct number of suppliers' do
        expect(helper.suppliers_lot1b.size).to eq 22
      end

      it 'returns the correct suppliers' do
        expect(helper.suppliers_lot1b.pluck('name')).to eq ['Abbott-Dooley', 'Bogan-Koch', 'Dickens and Sons', 'Dickinson-Abbott', 'Ebert Inc', 'Feest-Blanda', 'Gleichner, Thiel and Weissnat', 'Graham-Farrell', 'Kemmer Inc', 'Lebsack, Vandervort and Veum', 'Leffler-Strosin', 'Mann Group', 'Marvin, Kunde and Cartwright', 'Nader, Prosacco and Gaylord', "O'Keefe LLC", "O'Keefe-Mitchell", 'Orn-Welch', 'Sanford LLC', 'Sanford-Lubowitz', 'Smitham-Brown', 'Treutel Inc', 'Wiza, Kunde and Gibson']
      end
    end

    context 'when considering suppliers_lot1c' do
      it 'returns the correct number of suppliers' do
        expect(helper.suppliers_lot1c.size).to eq 17
      end

      it 'returns the correct suppliers' do
        expect(helper.suppliers_lot1c.pluck('name')).to eq ['Abbott-Dooley', 'Dickens and Sons', 'Ebert Inc', 'Feest-Blanda', 'Gleichner, Thiel and Weissnat', 'Graham-Farrell', 'Huels, Borer and Rowe', 'Kemmer Inc', 'Mann Group', 'Nader, Prosacco and Gaylord', 'Orn-Welch', 'Sanford LLC', 'Sanford-Lubowitz', 'Smitham-Brown', 'Terry-Konopelski', 'Treutel Inc', 'Wiza, Kunde and Gibson']
      end
    end

    context 'when considering supplier_count' do
      it 'returns 48' do
        expect(helper.supplier_count).to eq 26
      end
    end
  end

  describe '.further_competition_saved_date' do
    let(:procurement) { create(:facilities_management_rm3830_procurement, contract_datetime:) }

    context 'when the contract_datetime is 01/02/2019 - 2:53pm' do
      let(:contract_datetime) { '01/02/2019 -  2:53pm' }

      it 'returns 1 February 2019, 2:53pm' do
        expect(helper.further_competition_saved_date(procurement)).to eq ' 1 February 2019,  2:53pm'
      end
    end

    context 'when the contract_datetime is 15/01/2020 - 11:05am' do
      let(:contract_datetime) { '15/01/2020 -  11:05am' }

      it 'returns 15 January 2020, 11:05am' do
        expect(helper.further_competition_saved_date(procurement)).to eq '15 January 2020, 11:05am'
      end
    end

    context 'when the contract_datetime is 06/09/2021 - 2:26am' do
      let(:contract_datetime) { '06/09/2021 - 2:26am' }

      it 'returns 6 September 2021, 3:26am' do
        expect(helper.further_competition_saved_date(procurement)).to eq ' 6 September 2021,  3:26am'
      end
    end

    context 'when the contract_datetime is 17/12/2020 -10:11pm' do
      let(:contract_datetime) { ' 17/12/2020 -10:11pm' }

      it 'returns 17 December 2020, 10:11pm' do
        expect(helper.further_competition_saved_date(procurement)).to eq '17 December 2020, 10:11pm'
      end
    end
  end

  describe '.contract_state_to_stage' do
    let(:result) { helper.contract_state_to_stage(contract_state) }

    context 'when the contract state is sent' do
      let(:contract_state) { 'sent' }

      it "returns 'Awaiting supplier response'" do
        expect(result).to eq 'Awaiting supplier response'
      end
    end

    context 'when the contract state is accepted' do
      let(:contract_state) { 'accepted' }

      it "returns 'Awaiting contract signature'" do
        expect(result).to eq 'Awaiting contract signature'
      end
    end

    context 'when the contract state is not_signed' do
      let(:contract_state) { 'not_signed' }

      it "returns 'Accepted, not signed'" do
        expect(result).to eq 'Accepted, not signed'
      end
    end

    context 'when the contract state is declined' do
      let(:contract_state) { 'declined' }

      it "returns 'Supplier declined'" do
        expect(result).to eq 'Supplier declined'
      end
    end

    context 'when the contract state is expired' do
      let(:contract_state) { 'expired' }

      it "returns 'No supplier response'" do
        expect(result).to eq 'No supplier response'
      end
    end
  end
end
