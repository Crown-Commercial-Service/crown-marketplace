require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Procurement do
  subject(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, user: user) }

  let(:user) { create(:user) }

  let(:current_year) { Date.current.year.to_s }
  let(:time) { Time.now.getlocal }
  let(:contract_datetime_value) { "#{time.strftime('%d/%m/%Y')} - #{time.strftime('%l:%M%P')}" }

  describe 'contract number generation' do
    let!(:fc_current_year_1) { create(:facilities_management_rm3830_procurement_further_competition, contract_number: "RM3830-FC0005-#{current_year}", contract_datetime: contract_datetime_value) }

    describe '.generate_contract_number' do
      let(:further_competition) { create(:facilities_management_rm3830_procurement_further_competition) }
      let(:number_array) { (1..9999).map { |integer| format('%04d', integer % 10000) } }
      let(:expected_number) { number_array.sample }

      # rubocop:disable RSpec/AnyInstance
      before { allow_any_instance_of(FacilitiesManagement::ContractNumberGenerator).to receive(:used_contract_numbers_for_current_year).and_return(number_array - [expected_number]) }
      # rubocop:enable RSpec/AnyInstance

      context 'with a procurement in further_competition' do
        it 'returns an available number for a further_competition contract' do
          expect(further_competition.send(:generate_contract_number_fc)).to eq("RM3830-FC#{expected_number}-#{current_year}")
        end
      end
    end

    context 'when contract_datetime format is created' do
      it 'returns value' do
        expect(fc_current_year_1.contract_datetime).to eq contract_datetime_value
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_one(:authorised_contact_detail).class_name('FacilitiesManagement::RM3830::ProcurementAuthorisedContactDetail') }
    it { is_expected.to have_one(:notices_contact_detail).class_name('FacilitiesManagement::RM3830::ProcurementNoticesContactDetail') }
    it { is_expected.to have_one(:invoice_contact_detail).class_name('FacilitiesManagement::RM3830::ProcurementInvoiceContactDetail') }
  end

  describe '#contract_name' do
    context 'when the name is more than 100 characters' do
      it 'is expected to not be valid' do
        procurement.contract_name = (0...101).map { ('a'..'z').to_a[rand(26)] }.join
        expect(procurement.valid?(:contract_name)).to be false
      end
    end

    context 'when the name is blank' do
      it 'is expected to not be valid' do
        procurement.contract_name = ''
        expect(procurement.valid?(:contract_name)).to be false
      end
    end

    context 'when the name is correct' do
      it 'expected to be valid' do
        procurement.contract_name = 'Valid Name'
        expect(procurement.valid?(:contract_name)).to be true
      end
    end
  end

  describe '#estimated_annual_cost' do
    context 'when estimated_cost_known is true' do
      context 'when estimated_annual_cost is present' do
        it 'expected to be valid' do
          procurement.estimated_cost_known = true
          procurement.estimated_annual_cost = 25000
          expect(procurement.valid?(:estimated_annual_cost)).to be true
        end
      end

      context 'when the estimated_annual_cost is not present' do
        it 'expected to not be valid' do
          procurement.estimated_cost_known = true
          procurement.estimated_annual_cost = nil
          expect(procurement.valid?(:estimated_annual_cost)).to be false
        end
      end
    end

    context 'when estimated_cost_known is false' do
      context 'when estimated_annual_cost is present' do
        it 'expected to be valid' do
          procurement.estimated_cost_known = false
          procurement.estimated_annual_cost = 25000
          expect(procurement.valid?(:estimated_annual_cost)).to be true
        end
      end

      context 'when the estimated_annual_cost is not present' do
        it 'expected to be valid' do
          procurement.estimated_cost_known = false
          expect(procurement.valid?(:estimated_annual_cost)).to be true
        end
      end
    end
  end

  describe '#payment_method' do
    context 'when a payment_method is not present' do
      it 'is expected not to be valid' do
        procurement.payment_method = ''
        expect(procurement.valid?(:payment_method)).to be false
      end
    end

    context 'when bacs is a selected payment_method' do
      it 'is expected to be valid' do
        procurement.payment_method = 'bacs'
        expect(procurement.valid?(:payment_method)).to be true
      end
    end

    context 'when card is a selected payment_method' do
      it 'is expected to be valid' do
        procurement.payment_method = 'card'
        expect(procurement.valid?(:payment_method)).to be true
      end
    end

    context 'when a payment_method already exists' do
      context 'when bacs is the payment_method' do
        before do
          procurement.payment_method = 'bacs'
        end

        it 'is expected to overwrite bacs' do
          procurement.payment_method = 'card'
          expect(procurement.payment_method).to eq 'card'
        end

        it 'is expected to revert back to bacs' do
          procurement.payment_method = 'card'
          procurement.payment_method = 'bacs'
          expect(procurement.payment_method).to eq 'bacs'
        end
      end

      context 'when card is the payment_method' do
        before do
          procurement.payment_method = 'card'
        end

        it 'is expected to overwrite card' do
          procurement.payment_method = 'bacs'
          expect(procurement.payment_method).to eq 'bacs'
        end

        it 'is expected to revert back to card' do
          procurement.payment_method = 'bacs'
          procurement.payment_method = 'card'
          expect(procurement.payment_method).to eq 'card'
        end
      end
    end
  end

  describe '#procurement_buildings' do
    context 'when there are no procurement_buildings on the procurement_buildings step' do
      it 'expected to be invalid' do
        procurement.procurement_buildings.destroy_all
        expect(procurement.valid?(:buildings)).to be false
      end
    end

    context 'when there are no active procurement_buildings on the procurement_buildings step' do
      it 'expected to be invalid' do
        procurement.procurement_buildings.first.update(active: false)
        expect(procurement.valid?(:buildings)).to be false
      end
    end

    context 'when there is an active procurement_building on the procurement_buildings step' do
      it 'expected to be valid' do
        procurement.save
        procurement.procurement_buildings.create(active: true)
        expect(procurement.valid?(:buildings)).to be true
      end
    end

    # rubocop:disable Rails/SkipsModelValidations
    context 'when the procurement_building is present with a service code' do
      it 'expected to be valid' do
        procurement.save
        procurement.procurement_buildings.create
        procurement.procurement_buildings.first.update_column(:service_codes, ['test'])
        expect(procurement.valid?(:buildings_and_services)).to be true
      end
    end
    # rubocop:enable Rails/SkipsModelValidations

    context 'when the procurement_building is present but without any service codes' do
      it 'expected to not be valid' do
        procurement.save
        procurement_building = procurement.procurement_buildings.create(active: true)
        allow(procurement_building.building).to receive(:building_name).and_return('asa')
        expect(procurement_building.valid?(:buildings_and_services)).to be false
      end
    end
  end

  describe 'validations on :continue' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_without_procurement_buildings, user: user) }
    let(:building) { create(:facilities_management_building, user: user) }

    context 'with valid scenarios' do
      before do
        procurement.update(service_codes: service_codes)
        procurement.procurement_buildings.create(building_id: building.id, service_codes: service_codes, active: true)
      end

      context 'when all status are completed' do
        let(:service_codes) { ['E.4'] }

        before do
          procurement.procurement_building_services.each do |procurement_building_service|
            procurement_building_service.update(no_of_appliances_for_testing: 59)
          end
        end

        it 'returns true' do
          expect(procurement.valid?(:continue)).to be true
        end
      end

      context 'when all status are completed and service requirements are not_required' do
        let(:service_codes) { ['C.19', 'D.3'] }

        it 'returns true' do
          expect(procurement.valid?(:continue)).to be true
        end
      end
    end

    context 'with invalid scenarios' do
      def continue_error_list
        procurement.errors.details[:base].map.with_index { |detail, index| [detail[:error], procurement.errors[:base][index]] }.to_h
      end

      context 'when all statuses are not_started or cannot_start' do
        before do
          %i[estimated_cost_known tupe initial_call_off_period_years initial_call_off_period_months initial_call_off_start_date mobilisation_period_required extensions_required].each do |attribute|
            procurement[attribute] = nil
          end
          procurement.service_codes = []
          procurement.save
          procurement.valid?(:continue)
        end

        it 'is not valid' do
          expect(procurement.errors.any?).to be true
        end

        it 'has the correct errors' do
          expected_error_list = {
            estimated_annual_cost_incomplete: '‘Estimated annual cost’ must be ‘COMPLETED’',
            tupe_incomplete: '‘TUPE’ must be ‘COMPLETED’',
            contract_period_incomplete: '‘Contract period’ must be ‘COMPLETED’',
            services_incomplete: '‘Services’ must be ‘COMPLETED’',
            buildings_incomplete: '‘Buildings’ must be ‘COMPLETED’',
            buildings_and_services_incomplete: '‘Assigning services to buildings’ must be ‘COMPLETED’',
            service_requirements_incomplete: '‘Service requirements’ must be ‘COMPLETED’'
          }

          expect(continue_error_list).to eq expected_error_list
        end
      end

      context 'when all other statuses are completed and buildings_and_services is incomplete' do
        before do
          procurement.procurement_buildings.create(building_id: building.id, active: true)
          procurement.valid?(:continue)
        end

        it 'is not valid' do
          expect(procurement.errors.any?).to be true
        end

        it 'has the correct errors' do
          expected_error_list = {
            buildings_and_services_incomplete: '‘Assigning services to buildings’ must be ‘COMPLETED’',
            service_requirements_incomplete: '‘Service requirements’ must be ‘COMPLETED’'
          }

          expect(continue_error_list).to eq expected_error_list
        end
      end

      context 'when all other statuses are completed and service_requirements_status is incomplete' do
        before do
          procurement.procurement_buildings.create(building_id: building.id, service_codes: procurement.service_codes, active: true)
          procurement.valid?(:continue)
        end

        it 'is not valid' do
          expect(procurement.errors.any?).to be true
        end

        it 'has the correct errors' do
          expected_error_list = {
            service_requirements_incomplete: '‘Service requirements’ must be ‘COMPLETED’'
          }

          expect(continue_error_list).to eq expected_error_list
        end
      end

      # rubocop:disable RSpec/NestedGroups
      context 'when all services are completed' do
        before do
          procurement.procurement_buildings.create(building_id: building.id, service_codes: procurement.service_codes, active: true)

          procurement.procurement_building_services.each do |procurement_building_service|
            procurement_building_service.update(service_standard: 'A')
          end
        end

        context 'and initial call off start date is in the past' do
          before do
            procurement.update(initial_call_off_start_date: Time.now.in_time_zone('London') - 10.days, mobilisation_period_required: false)
            procurement.valid?(:continue)
          end

          it 'is not valid' do
            expect(procurement.errors.any?).to be true
          end

          it 'has the correct errors' do
            expected_error_list = {
              initial_call_off_period_in_past: 'Initial call-off period start date must not be in the past'
            }

            expect(continue_error_list).to eq expected_error_list
          end
        end

        context 'and mobilisation period is in the past' do
          before do
            procurement.update(initial_call_off_start_date: Time.now.in_time_zone('London') + 2.days)
            procurement.valid?(:continue)
          end

          it 'is not valid' do
            expect(procurement.errors.any?).to be true
          end

          it 'has the correct errors' do
            expected_error_list = {
              mobilisation_period_in_past: 'Mobilisation period start date must not be in the past'
            }

            expect(continue_error_list).to eq expected_error_list
          end
        end

        context 'and mobilisation period is not valid for tupe' do
          before do
            procurement.update(tupe: true, mobilisation_period_required: false)
            procurement.valid?(:continue)
          end

          it 'is not valid' do
            expect(procurement.errors.any?).to be true
          end

          it 'has the correct errors' do
            expected_error_list = {
              mobilisation_period_required: 'Mobilisation period length must be a minimum of 4 weeks when TUPE is selected'
            }

            expect(continue_error_list).to eq expected_error_list
          end
        end

        context 'when a building is missing a region' do
          before { procurement.procurement_buildings.first.building.update(address_region_code: nil) }

          it 'is not valid' do
            expect(procurement.valid?(:continue)).to be false
          end
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end

  describe '#all_complete' do
    context 'when the procurement is beyond requirements' do
      %i[choose_contract_value results da_draft direct_award further_competition closed].each do |state|
        before { procurement.update(aasm_state: state) }

        it "will be nil for a state of #{state}" do
          expect(procurement.send(:all_complete)).to be_nil
        end
      end
    end
  end

  describe '#update_building_services' do
    before do
      procurement.procurement_buildings.first.procurement_building_services.destroy_all

      procurement.procurement_buildings.first.update(service_codes: procurement.service_codes)

      procurement.service_codes = ['C.3']
    end

    it 'will remove any procurement_building_services that have a service code not included in the procurement service_codes' do
      expect { procurement.save }.to change { procurement.procurement_building_services.count }.by(-2)
    end

    it 'will remove service codes from the procurement_buildings service codes that are not selected for the procurement' do
      expect { procurement.save }.to change { procurement.procurement_buildings.first.service_codes }.from(['C.1', 'C.2']).to([])
    end
  end

  describe '#requires_service_information' do
    context 'when a building has services that require questions' do
      it 'is in the array' do
        procurement_building = create(:facilities_management_rm3830_procurement_building, procurement: procurement, service_codes: ['C.5', 'E.4', 'K.8'])
        expect(procurement.procurement_buildings.requires_service_information).to eq [procurement_building]
      end
    end

    context 'when a building has no services that require questions' do
      it 'is not in the array' do
        procurement_building = create(:facilities_management_rm3830_procurement_building, procurement: procurement, service_codes: ['K.11', 'K.14', 'K.8'])
        expect(procurement.procurement_buildings.requires_service_information).not_to eq [procurement_building]
      end
    end

    context 'when a building has a service that require questions' do
      it 'is in the array' do
        procurement_building = create(:facilities_management_rm3830_procurement_building, procurement: procurement, service_codes: ['K.7'])
        expect(procurement.procurement_buildings.requires_service_information).to eq [procurement_building]
      end
    end

    context 'when a building has no services' do
      it 'is not in the array' do
        procurement_building = create(:facilities_management_rm3830_procurement_building, procurement: procurement, service_codes: [])
        expect(procurement.procurement_buildings.requires_service_information).not_to eq [procurement_building]
      end
    end
  end

  describe '#set_state_to_results_if_possible' do
    let(:supplier_ids) { FacilitiesManagement::RM3830::SupplierDetail.first(2).pluck(:supplier_id) }
    let(:da_value_test) { 865.2478374540002 }
    let(:da_value_test1) { 1517.20280381278 }
    let(:obj) { double }

    before do
      allow(FacilitiesManagement::RM3830::AssessedValueCalculator).to receive(:new).with(procurement.id).and_return(obj)
      allow(obj).to receive(:assessed_value).and_return(0.1234)
      allow(obj).to receive(:lot_number).and_return('1a')
      allow(obj).to receive(:sorted_list).and_return([{ supplier_name: 'test', supplier_id: supplier_ids[0], da_value: da_value_test }, { supplier_name: 'test1', supplier_id: supplier_ids[1], da_value: da_value_test1 }])
    end

    context 'when no eligible suppliers' do
      it 'does not create any procurement suppliers' do
        allow(obj).to receive(:sorted_list).and_return([])
        expect { procurement.set_state_to_results_if_possible }.not_to change(FacilitiesManagement::RM3830::ProcurementSupplier, :count)
      end
    end

    context 'when some eligible suppliers' do
      it 'creates procurement_suppliers' do
        expect { procurement.set_state_to_results_if_possible }.to change(FacilitiesManagement::RM3830::ProcurementSupplier, :count).by(2)
      end

      it 'creates procurement_suppliers with the right direct award value' do
        procurement.set_state_to_results_if_possible
        expect(procurement.procurement_suppliers.first.direct_award_value).to eq da_value_test
        expect(procurement.procurement_suppliers.last.direct_award_value).to eq da_value_test1
      end

      it 'creates procurement_suppliers with the right supplier id' do
        procurement.set_state_to_results_if_possible
        expect(procurement.procurement_suppliers.first.supplier_id).to eq supplier_ids[0]
      end

      it 'saves assessed_value' do
        procurement.set_state_to_results_if_possible
        expect(procurement.assessed_value).not_to be_nil
      end

      it 'saves lot_number' do
        procurement.set_state_to_results_if_possible
        expect(procurement.lot_number).not_to be_nil
      end

      it 'create a frozen rate' do
        procurement.set_state_to_results_if_possible
        expect(FacilitiesManagement::RM3830::FrozenRate.where(facilities_management_rm3830_procurement_id: procurement.id).size).to eq 155
        expect(FacilitiesManagement::RM3830::FrozenRateCard.where(facilities_management_rm3830_procurement_id: procurement.id).size).to eq 1
      end
    end

    describe 'changing state' do
      let(:procurement_building) { create(:facilities_management_rm3830_procurement_building_no_services, procurement: procurement) }
      let(:estimated_cost_known) { nil }
      let(:services_standard) { nil }

      before do
        procurement.procurement_buildings.destroy_all
        codes.each_with_index do |code, index|
          create(:facilities_management_rm3830_procurement_building_service, code: code, service_standard: services_standard[index], procurement_building: procurement_building)
        end
        procurement.update(estimated_cost_known: estimated_cost_known, da_journey_state: 'review')
        procurement.set_state_to_results_if_possible!
      end

      context 'when customer has all services unpriced and no buyer input' do
        let(:codes) { %w[L.6 L.7 L.8] }
        let(:services_standard) { [nil, nil, nil] }

        it 'changes state to choose_contract_value' do
          expect(procurement.aasm_state).to eq 'choose_contract_value'
        end

        it 'does not start da_journey' do
          expect(procurement.da_journey_state).not_to eq 'pricing'
        end

        it 'some_services_unpriced_and_no_buyer_input? returns true' do
          expect(procurement.some_services_unpriced_and_no_buyer_input?).to be true
        end

        it 'procurement_building_services_not_used_in_calculation returns a list with L.6, L.7 and L.8' do
          expect(procurement.procurement_building_services_not_used_in_calculation.size).to eq 3
        end

        it 'eligible_for_da returns false' do
          expect(procurement.eligible_for_da).to be false
        end

        it 'does not save lot number' do
          expect(procurement.lot_number).to be_nil
        end
      end

      context 'when customer has unpriced services, a percentage service and no buyer input' do
        let(:codes) { %w[L.6 L.7 M.1] }
        let(:services_standard) { [nil, nil, nil] }

        it 'changes state to choose_contract_value' do
          expect(procurement.aasm_state).to eq 'choose_contract_value'
        end

        it 'does not start da_journey' do
          expect(procurement.da_journey_state).not_to eq 'pricing'
        end

        it 'some_services_unpriced_and_no_buyer_input? returns true' do
          expect(procurement.some_services_unpriced_and_no_buyer_input?).to be true
        end

        it 'procurement_building_services_not_used_in_calculation returns a list with L.6 and L.7' do
          expect(procurement.procurement_building_services_not_used_in_calculation.size).to eq 2
        end

        it 'eligible_for_da returns false' do
          expect(procurement.eligible_for_da).to be false
        end

        it 'does not save lot number' do
          expect(procurement.lot_number).to be_nil
        end
      end

      context 'when customer has some services unpriced and no buyer input' do
        let(:codes) { %w[G.1 L.7 L.8] }
        let(:services_standard) { ['A', nil, nil] }

        it 'changes state to choose_contract_value' do
          expect(procurement.aasm_state).to eq 'choose_contract_value'
        end

        it 'does not start da_journey' do
          expect(procurement.da_journey_state).not_to eq 'pricing'
        end

        it 'some_services_unpriced_and_no_buyer_input? returns true' do
          expect(procurement.some_services_unpriced_and_no_buyer_input?).to be true
        end

        it 'procurement_building_services_not_used_in_calculation returns a list with L.7 and L.8' do
          unpriced_services = procurement.procurement_building_services_not_used_in_calculation
          expect(unpriced_services.size).to eq 2
        end

        it 'eligible_for_da returns false' do
          expect(procurement.eligible_for_da).to be false
        end

        it 'does save lot number' do
          expect(procurement.lot_number).not_to be_nil
        end
      end

      context 'when buyer has priced services and unused services and no buyer input' do
        let(:codes) { %w[C.1 C.2 M.1 N.1] }
        let(:services_standard) { ['A', 'A', nil, nil] }

        it 'some_services_unpriced_and_no_buyer_input? returns false' do
          expect(procurement.some_services_unpriced_and_no_buyer_input?).to be false
        end

        it 'procurement_building_services_not_used_in_calculation returns a list without any services' do
          expect(procurement.procurement_building_services_not_used_in_calculation.size).to eq 0
        end

        it 'eligible_for_da returns false' do
          expect(procurement.eligible_for_da).to be true
        end

        it 'does save lot number' do
          expect(procurement.lot_number).not_to be_nil
        end
      end

      context 'when customer has some services unpriced and when buyer input present' do
        let(:codes) { %w[G.1 J.7 L.8] }
        let(:services_standard) { ['A', nil, nil] }
        let(:estimated_cost_known) { true }

        it 'some_services_unpriced_and_no_buyer_input? returns false' do
          expect(procurement.some_services_unpriced_and_no_buyer_input?).to be false
        end

        it 'procurement_building_services_not_used_in_calculation returns a list with L.8 only' do
          expect(procurement.procurement_building_services_not_used_in_calculation.size).to eq 1
        end

        it 'eligible_for_da returns false' do
          expect(procurement.eligible_for_da).to be false
        end

        it 'does save lot number' do
          expect(procurement.lot_number).not_to be_nil
        end
      end

      context 'when customer has all services priced and buyer input is present' do
        let(:codes) { %w[I.1 I.2 I.3] }
        let(:services_standard) { [nil, nil, nil] }
        let(:estimated_cost_known) { true }

        it 'some_services_unpriced_and_no_buyer_input? returns false' do
          expect(procurement.some_services_unpriced_and_no_buyer_input?).to be false
        end

        it 'contract_value_needed? returns false' do
          expect(procurement.send(:contract_value_needed?)).to be false
        end

        it 'eligible_for_da returns true' do
          expect(procurement.eligible_for_da).to be true
        end

        it 'does save lot number' do
          expect(procurement.lot_number).not_to be_nil
        end
      end

      context 'when customer has all services priced, O.1 services and buyer input is not present' do
        let(:codes) { %w[I.1 I.2 O.1] }
        let(:services_standard) { [nil, nil, nil] }

        it 'some_services_unpriced_and_no_buyer_input? returns false' do
          expect(procurement.some_services_unpriced_and_no_buyer_input?).to be false
        end

        it 'contract_value_needed? returns false' do
          expect(procurement.send(:contract_value_needed?)).to be false
        end

        it 'changes state to results' do
          expect(procurement.aasm_state).to eq 'results'
        end

        it 'eligible_for_da returns false' do
          expect(procurement.eligible_for_da).to be true
        end

        it 'does save lot number' do
          expect(procurement.lot_number).not_to be_nil
        end

        it 'procurement_building_services_not_used_in_calculation an empty list' do
          expect(procurement.procurement_building_services_not_used_in_calculation.size).to eq 0
        end
      end
    end
  end

  describe '#offer_to_next_supplier' do
    let(:da_value_test) { 500 }
    let(:da_value_test1) { 1500 }
    let(:da_value_test2) { 1000 }
    let(:da_value_test3) { 2000 }
    let(:supplier_ids) { FacilitiesManagement::RM3830::SupplierDetail.first(4).pluck(:supplier_id) }

    before do
      [da_value_test, da_value_test1, da_value_test2, da_value_test3].each_with_index do |da_value, index|
        procurement.procurement_suppliers.create(direct_award_value: da_value, supplier_id: supplier_ids[index])
      end
      procurement.update(aasm_state: 'direct_award')
      allow(FacilitiesManagement::RM3830::GenerateContractZip).to receive(:perform_in).and_return(nil)
      allow(FacilitiesManagement::RM3830::ChangeStateWorker).to receive(:perform_at).and_return(nil)
      allow(FacilitiesManagement::RM3830::ContractSentReminder).to receive(:perform_at).and_return(nil)
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(FacilitiesManagement::RM3830::ProcurementSupplier).to receive(:send_email_to_supplier).and_return(nil)
      allow_any_instance_of(FacilitiesManagement::RM3830::ProcurementSupplier).to receive(:send_email_to_buyer).and_return(nil)
      # rubocop:enable RSpec/AnyInstance
    end

    stub_bank_holiday_json

    context 'when all contracts are unsent' do
      it 'will return true and the first contract will be sent' do
        expect(procurement.offer_to_next_supplier).to be true
        procurement.reload
        expect(procurement.procurement_suppliers.first.aasm_state).to eq 'sent'
      end

      it 'will set the first contract number' do
        expect(procurement.offer_to_next_supplier).to be true
        procurement.reload
        expect(procurement.procurement_suppliers.first.contract_number).not_to be_nil
      end

      it 'will not have a closed date' do
        expect(procurement.offer_to_next_supplier).to be true
        procurement.reload
        expect(procurement.procurement_suppliers.first.contract_closed_date).to be_nil
      end
    end

    context 'when some contracts are unsent' do
      before { procurement.offer_to_next_supplier }

      it 'will return true and the next contract will be sent' do
        expect(procurement.offer_to_next_supplier).to be true
        procurement.reload
        expect(procurement.procurement_suppliers[1].aasm_state).to eq 'sent'
      end

      it 'will set their contract numbers' do
        procurement.offer_to_next_supplier
        procurement.reload
        contract_numbers = procurement.procurement_suppliers[0..1].map(&:contract_number)
        expect(contract_numbers.any?(nil)).to be false
      end

      it 'only the first will have a closed date' do
        procurement.offer_to_next_supplier
        procurement.reload
        expect(procurement.procurement_suppliers[0].contract_closed_date).not_to be_nil
        expect(procurement.procurement_suppliers[1].contract_closed_date).to be_nil
      end

      it 'last sent offer returns false' do
        procurement.offer_to_next_supplier
        procurement.reload
        expect(procurement.procurement_suppliers.sent[0].last_offer?).to be false
        expect(procurement.procurement_suppliers.sent[1].last_offer?).to be false
      end
    end

    context 'when no contracts are unsent' do
      before { 4.times { procurement.offer_to_next_supplier } }

      it 'will return false and no contract states will be changed' do
        expect(procurement.offer_to_next_supplier).to be false
        procurement.reload
        closed_contracts = procurement.procurement_suppliers.map(&:aasm_state)
        expect(closed_contracts.all?('sent')).to be true
      end

      it 'the contracts will be sent in order of lowest direct award value' do
        procurement.reload

        sorted_contracts = procurement.procurement_suppliers.order(:direct_award_value)
        sorted_sent_contracts = procurement.procurement_suppliers.sent.order(:offer_sent_date)

        expect(sorted_sent_contracts).to match_array(sorted_contracts)
      end

      it 'will set their contract numbers' do
        procurement.reload
        contract_numbers = procurement.procurement_suppliers.map(&:contract_number)
        expect(contract_numbers.any?(nil)).to be false
      end

      it 'only the last will not have a closed date' do
        procurement.reload
        contract_closed_dates = procurement.procurement_suppliers.map(&:contract_closed_date)
        expect(contract_closed_dates[0..2].any?(nil)).to be false
        expect(contract_closed_dates.last).to be_nil
      end

      it 'last sent offer returns true' do
        procurement.offer_to_next_supplier
        procurement.reload
        procurement.procurement_suppliers.sent.each(&:decline!)
        sent_offers = procurement.procurement_suppliers.map(&:last_offer?)
        expect(sent_offers[0..2].any?(true)).to be false
        expect(sent_offers.last).to be true
      end
    end
  end

  describe '#priced_at_framework' do
    context 'when one of the services is not priced at framework' do
      before do
        procurement.procurement_building_services.first.update(code: 'C.1', service_standard: 'A')
        procurement.procurement_building_services.last.update(code: 'C.2', service_standard: 'C')
      end

      it 'returns false' do
        expect(procurement.send(:priced_at_framework)).to be false
      end
    end

    context 'when all services are priced at framework' do
      before do
        procurement.procurement_building_services.first.update(code: 'C.1', service_standard: 'A')
        procurement.procurement_building_services.last.update(code: 'C.2', service_standard: 'A')
      end

      it 'returns true' do
        expect(procurement.send(:priced_at_framework)).to be true
      end
    end
  end

  describe '#direct_award?' do
    context 'when the procurement is set to direct award' do
      it 'is expected to be true' do
        procurement.aasm_state = 'direct_award'

        expect(procurement.direct_award?).to be(true)
      end
    end

    context 'when the procurement is not set to direct award' do
      it 'is expected to be false' do
        expect(procurement.direct_award?).to be(false)
      end
    end
  end

  describe 'initial_call_off_period' do
    before do
      procurement.initial_call_off_period_years = initial_call_off_period_years
      procurement.initial_call_off_period_months = initial_call_off_period_months
    end

    context 'when the years are 0 and months 3' do
      let(:initial_call_off_period_years) { 0 }
      let(:initial_call_off_period_months) { 3 }

      it 'is 3 months' do
        expect(procurement.initial_call_off_period).to eq(3.months)
      end
    end

    context 'when the years are 4 and months are 0' do
      let(:initial_call_off_period_years) { 4 }
      let(:initial_call_off_period_months) { 0 }

      it 'is 4 years' do
        expect(procurement.initial_call_off_period).to eq(4.years)
      end
    end

    context 'when the years are 2 and months are 6' do
      let(:initial_call_off_period_years) { 2 }
      let(:initial_call_off_period_months) { 6 }

      it 'is 2 years and 6 months' do
        expect(procurement.initial_call_off_period).to eq(2.years + 6.months)
      end
    end
  end

  describe 'initial_call_off_end_date' do
    before do
      procurement.initial_call_off_period_years = initial_call_off_period_years
      procurement.initial_call_off_period_months = initial_call_off_period_months
      procurement.initial_call_off_start_date = initial_call_off_start_date
    end

    context 'when the start date is 2022/03/01 and the period is 3 years and 4 months' do
      let(:initial_call_off_start_date) { Time.new(2022, 3, 1).in_time_zone('London') }
      let(:initial_call_off_period_years) { 3 }
      let(:initial_call_off_period_months) { 4 }

      it 'the initial call-off end date is 2025/06/30' do
        expect(procurement.initial_call_off_end_date).to eq(Time.new(2025, 6, 30).in_time_zone('London').to_date)
      end
    end

    context 'when the start date is 2021/28/02 and the period is 6 years and 1 month' do
      let(:initial_call_off_start_date) { Time.new(2021, 2, 28).in_time_zone('London') }
      let(:initial_call_off_period_years) { 6 }
      let(:initial_call_off_period_months) { 1 }

      it 'the initial call-off end date is 2027/03/27' do
        expect(procurement.initial_call_off_end_date).to eq(Time.new(2027, 3, 27).in_time_zone('London').to_date)
      end
    end

    context 'when the start date is 2021/07/18 and the period is 1 years and 7 months' do
      let(:initial_call_off_start_date) { Time.new(2021, 7, 18).in_time_zone('London') }
      let(:initial_call_off_period_years) { 1 }
      let(:initial_call_off_period_months) { 7 }

      it 'the initial call-off end date is 2023/02/17' do
        expect(procurement.initial_call_off_end_date).to eq(Time.new(2023, 2, 17).in_time_zone('London').to_date)
      end
    end

    context 'when the start date is 2024/02/29 and the period is 5 years and 0 months' do
      let(:initial_call_off_start_date) { Time.new(2024, 2, 29).in_time_zone('London') }
      let(:initial_call_off_period_years) { 5 }
      let(:initial_call_off_period_months) { 0 }

      it 'the initial call-off end date is 2029/02/28' do
        expect(procurement.initial_call_off_end_date).to eq(Time.new(2029, 2, 28).in_time_zone('London').to_date)
      end
    end

    context 'when the start date is 2022/01/31 and the period is 0 years and 5 months' do
      let(:initial_call_off_start_date) { Time.new(2022, 1, 31).in_time_zone('London') }
      let(:initial_call_off_period_years) { 0 }
      let(:initial_call_off_period_months) { 5 }

      it 'the initial call-off end date is 2022/06/30' do
        expect(procurement.initial_call_off_end_date).to eq(Time.new(2022, 6, 30).in_time_zone('London').to_date)
      end
    end

    context 'when the start date is 2023/10/10 and the period is 6 years and 3 months' do
      let(:initial_call_off_start_date) { Time.new(2023, 10, 10).in_time_zone('London') }
      let(:initial_call_off_period_years) { 6 }
      let(:initial_call_off_period_months) { 3 }

      it 'the initial call-off end date is 2030/01/9' do
        expect(procurement.initial_call_off_end_date).to eq(Time.new(2030, 1, 9).in_time_zone('London').to_date)
      end
    end
  end

  describe 'mobilisation period start and end dates' do
    context 'when considering the mobilisation_end_date' do
      it 'is one day before the initial_call_off_start_date' do
        expect(procurement.mobilisation_end_date).to eq(procurement.initial_call_off_start_date - 1.day)
      end
    end

    context 'when considering the mobilisation_start_date' do
      before { procurement.mobilisation_period = mobilisation_period }

      context 'and the mobilisation_period is 2 weeks' do
        let(:mobilisation_period) { 2 }

        it 'is 2 weeks and a day before the initial_call_off_start_date' do
          expect(procurement.mobilisation_start_date).to eq(procurement.initial_call_off_start_date - 2.weeks - 1.day)
        end
      end

      context 'and the mobilisation_period is 4 weeks' do
        let(:mobilisation_period) { 4 }

        it 'is 4 weeks and a day before the initial_call_off_start_date' do
          expect(procurement.mobilisation_start_date).to eq(procurement.initial_call_off_start_date - 4.weeks - 1.day)
        end
      end

      context 'and the mobilisation_period is 8 weeks' do
        let(:mobilisation_period) { 8 }

        it 'is 8 weeks and a day before the initial_call_off_start_date' do
          expect(procurement.mobilisation_start_date).to eq(procurement.initial_call_off_start_date - 8.weeks - 1.day)
        end
      end
    end
  end

  describe 'extension periods start and end dates' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_with_extension_periods) }

    describe 'extension_period_start_date' do
      context 'when there is one extenesion period' do
        it 'is expected to return the date one day after the end of the initial call off period' do
          expect(procurement.extension_period_start_date(0)).to eq(procurement.initial_call_off_end_date + 1.day)
        end
      end

      context 'when there is a second extension period' do
        it 'is expected to return the date one day after the end of the first extension period' do
          extension_period_start_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..0).sum(&:period)

          expect(procurement.extension_period_start_date(1)).to eq(extension_period_start_date + 1.day)
        end
      end

      context 'when there is a third extension period' do
        it 'is expected to return the date one day after the end of the second extension period' do
          extension_period_start_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..1).sum(&:period)

          expect(procurement.extension_period_start_date(2)).to eq(extension_period_start_date + 1.day)
        end
      end

      context 'when there is a forth extension period' do
        it 'is expected to return the date one day after the end of the third extension period' do
          extension_period_start_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..2).sum(&:period)

          expect(procurement.extension_period_start_date(3)).to eq(extension_period_start_date + 1.day)
        end
      end
    end

    describe 'extension_period_end_date' do
      context 'when there is one extenesion period' do
        it 'is expected to return the date one year after the end of the initial call off period' do
          extension_period_end_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..0).sum(&:period)

          expect(procurement.extension_period_end_date(0)).to eq(extension_period_end_date)
        end
      end

      context 'when there is a second extension period' do
        it 'is expected to return the date one year after the end of the first extension period' do
          extension_period_end_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..1).sum(&:period)

          expect(procurement.extension_period_end_date(1)).to eq(extension_period_end_date)
        end
      end

      context 'when there is a third extension period' do
        it 'is expected to return the date one year after the end of the second extension period' do
          extension_period_end_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..2).sum(&:period)

          expect(procurement.extension_period_end_date(2)).to eq(extension_period_end_date)
        end
      end

      context 'when there is a forth extension period' do
        it 'is expected to return the date one year after the end of the third extension period' do
          extension_period_end_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..3).sum(&:period)

          expect(procurement.extension_period_end_date(3)).to eq(extension_period_end_date)
        end
      end
    end
  end

  describe '#more_than_max_pensions?' do
    let(:pension_fund) { build(:facilities_management_rm3830_procurement_pension_fund, procurement: create(:facilities_management_rm3830_procurement)) }
    let(:attributes) { ActiveSupport::HashWithIndifferentAccess.new(pension_fund.attributes) }

    before { attributes['percentage'] = attributes['percentage'].to_s }

    # validating number of record
    context 'when the number of records is greater than 99' do
      it 'only assignes the first 99 pension funds' do
        nested_attributes = {
          procurement_pension_funds_attributes: (0..99).to_h { |index| [index.to_s, { case_sensitive_error: false, name: Faker::Name.unique.name[1..150], percentage: rand(1..100).to_s, _destroy: false }] }
        }

        procurement.assign_attributes(nested_attributes)

        expect(procurement.procurement_pension_funds.length).to eq 99
      end
    end
  end

  describe '#before_each_procurement_pension_funds verify' do
    let(:pension_fund1) { build(:facilities_management_rm3830_procurement_pension_fund, procurement: create(:facilities_management_rm3830_procurement)) }
    let(:pension_fund2) { build(:facilities_management_rm3830_procurement_pension_fund, procurement: create(:facilities_management_rm3830_procurement)) }

    context 'when the name is not case sensitive' do
      it 'can be saved if name is not case sensitive' do
        pension_fund2.name = "#{pension_fund1.name}abc"
        procurement.procurement_pension_funds = [pension_fund1, pension_fund2]
        expect(pension_fund1.case_sensitive_error).to be false
        expect(pension_fund2.case_sensitive_error).to be false
      end

      it 'cannot be saved if name is case sensitive' do
        pension_fund2.name = pension_fund1.name.upcase
        expect { procurement.procurement_pension_funds = [pension_fund1, pension_fund2] }.to raise_exception(ActiveRecord::RecordNotSaved)
        expect(pension_fund1.case_sensitive_error).to be false
        expect(pension_fund2.case_sensitive_error).to be true
      end
    end
  end

  describe 'further competition verify' do
    context 'when further competition is valid' do
      it 'is expected to be true' do
        procurement.aasm_state = 'further_competition'
        expect(procurement.further_competition?).to be(true)
      end

      it 'is expected to be false' do
        expect(procurement.further_competition?).to be(false)
      end
    end
  end

  describe 'services missing prices' do
    let(:procurement_building) { create(:facilities_management_rm3830_procurement_building_no_services, procurement: procurement) }

    before do
      procurement.procurement_buildings.destroy_all
      codes.each do |code|
        create(:facilities_management_rm3830_procurement_building_service, code: code, procurement_building: procurement_building)
      end
      procurement.update(estimated_cost_known: estimated_cost_known)
    end

    context 'when buyer input not present' do
      let(:estimated_cost_known) { false }

      context 'when all services are missing FW & BM prices' do
        let(:codes) { %w[L.6 L.7 L.8] }

        it 'all_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)).to be true
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)).to be true
        end

        it 'all_services_missing_framework_and_benchmark_price? returns true' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)).to be true
        end
      end

      context 'when all but one service missing FW price' do
        let(:codes) { %w[G.1 G.2 D.6] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)).to be false
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)).to be false
        end

        it 'all_services_missing_framework_and_benchmark_price? returns false' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)).to be false
        end
      end

      context 'when all but one service missing BM and FW price' do
        let(:codes) { %w[G.1 G.2 L.6] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)).to be false
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)).to be true
        end

        it 'all_services_missing_framework_and_benchmark_price? returns false' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)).to be false
        end
      end

      context 'when the services include unused services and one unpriced service' do
        let(:codes) { %w[D.3 M.1 O.1] }

        it 'all_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)).to be true
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)).to be true
        end

        it 'all_services_missing_framework_and_benchmark_price? returns true' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)).to be true
        end
      end

      context 'when the services include the two unused services and one priced service' do
        let(:codes) { %w[C.1 M.1 N.1] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)).to be false
        end

        it 'some_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)).to be false
        end

        it 'all_services_missing_framework_and_benchmark_price? returns false' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)).to be false
        end
      end

      context 'when all the services are priced' do
        let(:codes) { %w[C.1 C.2 C.3] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)).to be false
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)).to be false
        end

        it 'all_services_missing_framework_and_benchmark_price? returns false' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)).to be false
        end
      end
    end

    context 'when buyer input present' do
      let(:estimated_cost_known) { true }

      context 'when all services are missing FW & BM prices' do
        let(:codes) { %w[L.6 L.7 L.8] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)).to be false
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)).to be false
        end

        it 'all_services_missing_framework_and_benchmark_price? returns true' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)).to be true
        end
      end

      context 'when all but one service missing FW price' do
        let(:codes) { %w[G.1 G.2 D.6] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)).to be false
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)).to be false
        end

        it 'all_services_missing_framework_and_benchmark_price? returns false' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)).to be false
        end
      end

      context 'when all but one service missing BM and FW price' do
        let(:codes) { %w[G.1 G.2 L.6] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)).to be false
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)).to be false
        end

        it 'all_services_missing_framework_and_benchmark_price? returns false' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)).to be false
        end
      end
    end
  end

  describe '#set_state_to_results' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_for_further_competition, aasm_state: state) }
    let(:building) { create(:facilities_management_building_london) }

    before do
      procurement.send(:copy_procurement_buildings_data)
      procurement.lot_number_selected_by_customer = lot_number_selected_by_customer
      procurement.save
    end

    context 'when state of procurement is choose_contract_value' do
      let(:state) { 'choose_contract_value' }

      context 'when lot_number_selected_by_customer is true' do
        let(:lot_number_selected_by_customer) { true }

        it 'sets state to results' do
          expect(procurement.aasm_state).to eq 'results'
        end
      end

      context 'when lot_number_selected_by_customer is false' do
        let(:lot_number_selected_by_customer) { false }

        it 'does not set state to results' do
          expect(procurement.aasm_state).not_to eq 'results'
        end
      end
    end

    context 'when state of procurement is not choose_contract_value' do
      let(:state) { 'quick_search' }
      let(:lot_number_selected_by_customer) { true }

      it 'does not set state to results' do
        expect(procurement.aasm_state).not_to eq 'results'
      end
    end
  end

  describe '#freeze_procurement_data' do
    context 'when moving from detailed_search to results' do
      it 'freezes the building and rate card data' do
        building = procurement.procurement_buildings.first.building
        building.update(gia: 1010, external_area: 2020)

        procurement.set_state_to_results_if_possible!

        procurement.reload

        expect(procurement.procurement_buildings.first.gia).to eq 1010
        expect(procurement.procurement_buildings.first.external_area).to eq 2020
      end
    end

    context 'when moving from any other state to results' do
      it 'does not update the frozen building and rate card data' do
        building = procurement.procurement_buildings.first.building
        building.update(gia: 1010, external_area: 2020)
        procurement.update(aasm_state: :da_draft)

        procurement.set_state_to_results_if_possible!

        procurement.reload

        expect(procurement.procurement_buildings.first.gia).not_to eq 1010
        expect(procurement.procurement_buildings.first.external_area).not_to eq 2020
      end
    end
  end

  describe '.contract_name_status' do
    subject(:status) { procurement.contract_name_status }

    let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, contract_name: contract_name) }

    context 'when the contract name section has not been completed' do
      let(:contract_name) { '' }

      it 'has a status of not_started' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when the contract name section has been completed' do
      let(:contract_name) { 'My contract name' }

      it 'has a status of completed' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.estimated_annual_cost_status' do
    subject(:status) { procurement.estimated_annual_cost_status }

    let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, estimated_cost_known: estimated_cost_known) }

    context 'when the estimated cost section has not been completed' do
      let(:estimated_cost_known) { nil }

      it 'has a status of not_started' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when the estimated cost section has not been' do
      let(:estimated_cost_known) { false }

      it 'has a status of completed' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.tupe_status' do
    subject(:status) { procurement.tupe_status }

    let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, tupe: tupe) }

    context 'when the tupe section has not been completed' do
      let(:tupe) { nil }

      it 'has a status of not_started' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when the tupe section has been completed' do
      let(:tupe) { true }

      it 'has a status of completed' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.contract_period_status' do
    subject(:status) { procurement.contract_period_status }

    context 'when all contract period sections have not been started' do
      let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, initial_call_off_period_years: nil, initial_call_off_period_months: nil, initial_call_off_start_date: nil, mobilisation_period_required: nil, extensions_required: nil) }

      it 'has a status of not_started' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when all contract period sections have not been completed' do
      let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, initial_call_off_period_months: nil, mobilisation_period_required: false, extensions_required: false) }

      it 'has a status of not_started' do
        expect(status).to eq(:incomplete)
      end
    end

    context 'when all contract period sections have been completed' do
      let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, mobilisation_period_required: false, extensions_required: false) }

      it 'has a status of completed' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.services_status' do
    subject(:status) { procurement.services_status }

    let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, service_codes: service_codes) }

    context 'when user has not yet selected services' do
      let(:service_codes) { [] }

      it 'shown with the NOT STARTED status label' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when user has already selected services' do
      let(:service_codes) { %w[C.1 C.2] }

      it 'shown with the COMPLETED status label' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.buildings_status' do
    subject(:status) { procurement.buildings_status }

    context 'when user has not yet selected buildings' do
      let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }

      it 'shown with the NOT STARTED status label' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when user has already selected buildings' do
      let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search) }

      it 'shown with the COMPLETED status label' do
        expect(status).to eq(:completed)
      end
    end
  end

  shared_context 'with buildings and services' do
    let(:procurement) do
      create(:facilities_management_rm3830_procurement_detailed_search, procurement_buildings: procurement_buildings)
    end

    let(:procurement_buildings) { [procurement_building1, procurement_building2] }

    let(:procurement_building1) { build(:facilities_management_rm3830_procurement_building) }
    let(:procurement_building2) { build(:facilities_management_rm3830_procurement_building) }

    before do
      procurement.update(aasm_state: 'detailed_search')
    end
  end

  describe '.buildings_and_services_completed' do
    include_context 'with buildings and services'

    before do
      procurement_building1.update(service_codes: service_codes)
      procurement_building2.update(service_codes: %w[C.1 C.2])
    end

    context 'when one building has no service codes' do
      let(:service_codes) { [] }

      it 'returns false' do
        expect(procurement.buildings_and_services_completed?).to be false
      end
    end

    context 'when one building has an invalid selection' do
      let(:service_codes) { %w[M.1 N.1 O.1] }

      it 'returns false' do
        expect(procurement.buildings_and_services_completed?).to be false
      end
    end

    context 'when both buildings have a valid selection' do
      let(:service_codes) { %w[M.1 N.1 O.1 C.1] }

      it 'returns true' do
        expect(procurement.buildings_and_services_completed?).to be true
      end
    end
  end

  describe '.buildings_and_services_status' do
    subject(:status) { procurement.buildings_and_services_status }

    include_context 'with buildings and services'

    context 'when both Services and Buildings tasks are not COMPLETED yet' do
      before do
        allow(procurement).to receive(:services_status).and_return(:not_started)
        allow(procurement).to receive(:buildings_status).and_return(:not_started)
      end

      it 'shown with the CANNOT START YET status label' do
        expect(status).to eq(:cannot_start)
      end
    end

    context 'when both Services and Buildings tasks are COMPLETED' do
      before do
        allow(procurement).to receive(:services_status).and_return(:completed)
        allow(procurement).to receive(:buildings_status).and_return(:completed)
      end

      context 'when no service has been assigned to any building yet' do
        before do
          procurement_building1.procurement_building_services.delete_all
          procurement_building2.procurement_building_services.delete_all
        end

        it 'shown with the NOT STARTED status label' do
          expect(status).to eq(:incomplete)
        end
      end

      context 'when at least one service is assigned to each and every building' do
        before do
          procurement_building1.update(service_codes: ['C.1'])
          procurement_building2.update(service_codes: ['D.1', 'E.4', 'M.1'])
        end

        it 'shown with the COMPLETED status label' do
          expect(status).to eq(:completed)
        end
      end
    end
  end

  describe '.service_requirements_status' do
    subject(:status) { procurement.service_requirements_status }

    include_context 'with buildings and services'

    context 'when the Assigning services to buildings task is not COMPLETED yet' do
      before do
        allow(procurement).to receive(:buildings_and_services_status).and_return(:not_started)
      end

      it 'shown with the CANNOT START YET status label' do
        expect(status).to eq(:cannot_start)
      end
    end

    context 'when Assigning services to buildings task is COMPLETED' do
      before do
        allow(procurement).to receive(:buildings_and_services_status).and_return(:completed)

        procurement_building1.procurement_building_services.delete_all
        procurement_building2.procurement_building_services.delete_all

        procurement_building1.update(service_codes: ['C.1'])
        procurement_building2.update(service_codes: ['G.5'])

        procurement_building1.procurement_building_services.first.update(service_standard: 'A')
        procurement_building2.procurement_building_services.first.update(service_standard: 'A')
      end

      context 'when no volumes or standards are required for any services' do
        before do
          procurement.update(service_codes: ['C.1', 'C.19', 'D.3'])

          procurement_building1.procurement_building_services.delete_all
          procurement_building2.procurement_building_services.delete_all

          procurement_building1.update(service_codes: ['C.19'])
          procurement_building2.update(service_codes: ['D.3'])
        end

        it 'shown with the NOT REQUIRED status label' do
          expect(status).to eq(:not_required)
        end
      end

      context 'when all the buildings service requirements have not yet been COMPLETED' do
        before do
          procurement_building1.building.update(gia: 0)
          procurement_building2.building.update(external_area: 0)
        end

        it 'shown with the INCOMPLETE status label' do
          expect(status).to eq(:incomplete)
        end
      end

      context 'when all buildings service requirements have been COMPLETED' do
        it 'shown with the COMPLETED status label' do
          expect(status).to eq(:completed)
        end
      end
    end

    context 'when having service which requires different units of measure' do
      before do
        allow(procurement).to receive(:buildings_and_services_status).and_return(:completed)

        procurement_building1.procurement_building_services.delete_all
        procurement_building2.procurement_building_services.delete_all

        procurement_building1.update(service_codes: ['H.4'])
        procurement_building2.update(service_codes: ['I.1'])

        procurement_building1.procurement_building_services.first.update(service_hours: 123, detail_of_requirement: 'Some reason')
        procurement_building2.procurement_building_services.first.update(service_hours: 456, detail_of_requirement: 'Some reason')
      end

      it 'shown with the COMPLETED status label' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.service_requirements_completed?' do
    context 'when the building is missing gia' do
      before do
        procurement.active_procurement_buildings.first.update(service_codes: ['C.1'])
        procurement.active_procurement_buildings.first.building.update(gia: 0)
        procurement.reload
      end

      it 'is not completed' do
        expect(procurement.service_requirements_completed?).to be false
      end
    end

    context 'when the building is missing external_area' do
      before do
        procurement.active_procurement_buildings.first.update(service_codes: ['G.5'])
        procurement.active_procurement_buildings.first.building.update(external_area: 0)
        procurement.reload
      end

      it 'is not completed' do
        expect(procurement.service_requirements_completed?).to be false
      end
    end

    context 'when the building is not missing gia or external_area' do
      before do
        procurement.active_procurement_buildings.first.update(service_codes: ['C.1', 'G.5'])
        procurement.procurement_building_services.update(service_standard: 'A')
        procurement.reload
      end

      it 'is not completed' do
        expect(procurement.service_requirements_completed?).to be true
      end
    end
  end

  describe '.services' do
    context 'when service codes are not in order' do
      before { procurement.update(service_codes: %w[E.4 D.3 C.6 H.10 G.3 C.11 K.5 L.7 C.1 E.7 I.3 C.5 C.17 C.14]) }

      it 'returns the service codes in the work_package order' do
        expect(procurement.services.map(&:code)).to eq %w[C.1 C.6 C.11 C.5 C.14 C.17 D.3 E.7 E.4 G.3 H.10 I.3 K.5 L.7]
      end
    end
  end

  describe '.can_be_deleted?' do
    state_with_results = {
      quick_search: true,
      detailed_search: true,
      detailed_search_bulk_upload: true,
      choose_contract_value: true,
      results: true,
      da_draft: true,
      direct_award: false,
      further_competition: false,
      closed: false
    }

    state_with_results.each do |state, result|
      context "when the procurement is in #{state}" do
        before { procurement.update(aasm_state: state) }.to_s

        it "#{result ? 'can' : 'cannot'} be deleted" do
          expect(procurement.can_be_deleted?).to be result
        end
      end
    end
  end

  describe '.building_data_frozen?' do
    state_with_results = {
      quick_search: false,
      detailed_search: false,
      detailed_search_bulk_upload: false,
      choose_contract_value: true,
      results: true,
      da_draft: true,
      direct_award: true,
      further_competition: true,
      closed: true
    }

    state_with_results.each do |state, result|
      context "when the procurement is in #{state}" do
        before { procurement.update(aasm_state: state) }.to_s

        it "the building data #{result ? 'is' : 'is not'} frozen" do
          expect(procurement.building_data_frozen?).to be result
        end
      end
    end
  end

  describe '.procurement_buildings_missing_regions?' do
    context 'when the procurement is in a quick_search state' do
      before { procurement.update(aasm_state: 'quick_search') }

      it 'returns false' do
        expect(procurement.procurement_buildings_missing_regions?).to be false
      end
    end

    context 'when the procurement is in detailed_search' do
      before { procurement.update(aasm_state: 'detailed_search') }

      context 'when a building address region is nil' do
        before { procurement.active_procurement_buildings.first.building.update(address_region_code: nil) }

        it 'returns true' do
          expect(procurement.procurement_buildings_missing_regions?).to be true
        end
      end

      context 'when a building address region is empty' do
        before { procurement.active_procurement_buildings.first.building.update(address_region_code: '') }

        it 'returns true' do
          expect(procurement.procurement_buildings_missing_regions?).to be true
        end
      end

      context 'when a building address region is present' do
        it 'returns false' do
          expect(procurement.procurement_buildings_missing_regions?).to be false
        end
      end
    end
  end

  describe '.unsent_direct_award_offers' do
    let(:contract1) { procurement.procurement_suppliers[0] }
    let(:contract2) { procurement.procurement_suppliers[1] }
    let(:contract3) { procurement.procurement_suppliers[2] }
    let(:contract4) { procurement.procurement_suppliers[3] }

    let(:state1) { 'unsent' }
    let(:state2) { 'unsent' }
    let(:state3) { 'unsent' }
    let(:state4) { 'unsent' }

    let(:da_values) { [10000, 100000, 1499999, 1500000] }
    let(:supplier_ids) { FacilitiesManagement::RM3830::SupplierDetail.first(4).pluck(:supplier_id) }
    let(:states) { [state1, state2, state3, state4] }

    before do
      da_values.each_with_index do |value, index|
        procurement.procurement_suppliers.create(direct_award_value: value, supplier_id: supplier_ids[index], aasm_state: states[index])
      end
    end

    context 'when there are 4 unsent offers with 3 in range' do
      it 'returns the three in range' do
        expect(procurement.unsent_direct_award_offers).to match [contract1, contract2, contract3]
      end
    end

    context 'when there are 4 offers with 3 unsent, and 3 in range' do
      let(:state1) { 'declined' }

      it 'returns the 2 unsent in range' do
        expect(procurement.unsent_direct_award_offers).to match [contract2, contract3]
      end
    end

    context 'when there are 4 offers with 0 unsent, and 3 in range' do
      let(:state1) { 'declined' }
      let(:state2) { 'expired' }
      let(:state3) { 'declined' }

      it 'returns no offers' do
        expect(procurement.unsent_direct_award_offers).to match []
      end
    end
  end

  describe '.contract_detail_incomplete?' do
    let(:result) { procurement.contract_detail_incomplete?(contact_detail) }

    context 'when considering invoice_contact_detail' do
      let(:contact_detail) { :invoice_contact_detail }

      context 'when there is no invoice_contact_detail' do
        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when there is invoice_contact_detail and it is complete' do
        before { create(:facilities_management_rm3830_procurement_invoice_contact_detail, procurement: procurement) }

        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when there is invoice_contact_detail and it is incomplete' do
        before { create(:facilities_management_rm3830_procurement_invoice_contact_detail_empty, procurement: procurement) }

        it 'returns true' do
          expect(result).to be true
        end
      end
    end

    context 'when considering authorised_contact_detail' do
      let(:contact_detail) { :authorised_contact_detail }

      context 'when there is no authorised_contact_detail' do
        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when there is authorised_contact_detail and it is complete' do
        before { create(:facilities_management_rm3830_procurement_authorised_contact_detail, procurement: procurement) }

        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when there is authorised_contact_detail and it is incomplete' do
        before { create(:facilities_management_rm3830_procurement_authorised_contact_detail_empty, procurement: procurement) }

        it 'returns true' do
          expect(result).to be true
        end
      end
    end

    context 'when considering notices_contact_detail' do
      let(:contact_detail) { :notices_contact_detail }

      context 'when there is no notices_contact_detail' do
        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when there is notices_contact_detail and it is complete' do
        before { create(:facilities_management_rm3830_procurement_notices_contact_detail, procurement: procurement) }

        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when there is notices_contact_detail and it is incomplete' do
        before { create(:facilities_management_rm3830_procurement_notices_contact_detail_empty, procurement: procurement) }

        it 'returns true' do
          expect(result).to be true
        end
      end
    end
  end

  describe 'validations on security_policy_document' do
    let(:security_policy_document_required) { true }
    let(:security_policy_document_name) { 'My Security Policy' }
    let(:security_policy_document_version_number) { '42' }
    let(:security_policy_document_date_dd) { nil }
    let(:security_policy_document_date_mm) { nil }
    let(:security_policy_document_date_yyyy) { nil }

    let(:security_policy_document_file) { Tempfile.new([content_type, ".#{extension}"]) }
    let(:security_policy_document_file_path) { fixture_file_upload(security_policy_document_file.path, content_type) }
    let(:content_type) { 'application/pdf' }
    let(:extension) { 'pdf' }

    before do
      procurement.security_policy_document_required = security_policy_document_required
      procurement.security_policy_document_name = security_policy_document_name
      procurement.security_policy_document_version_number = security_policy_document_version_number
      procurement.security_policy_document_date_dd = security_policy_document_date_dd
      procurement.security_policy_document_date_mm = security_policy_document_date_mm
      procurement.security_policy_document_date_yyyy = security_policy_document_date_yyyy
      procurement.security_policy_document_file = security_policy_document_file_path
    end

    after do
      security_policy_document_file.unlink
    end

    context 'when considering security_policy_document_required' do
      context 'and security_policy_document_required is nil' do
        let(:security_policy_document_required) { nil }

        it 'is not valid and has the correct error messages' do
          expect(procurement).not_to be_valid(:security_policy_document)
          expect(procurement.errors[:security_policy_document_required].first).to eq 'Select one option'
        end
      end

      context 'and security_policy_document_required is false' do
        let(:security_policy_document_required) { false }
        let(:security_policy_document_name) { nil }
        let(:security_policy_document_version_number) { nil }
        let(:security_policy_document_file_path) { nil }

        it 'is valid' do
          expect(procurement).to be_valid(:security_policy_document)
        end
      end
    end

    context 'when considering security_policy_document_name' do
      let(:security_policy_document_name) { nil }

      it 'is not valid and has the correct error messages' do
        expect(procurement).not_to be_valid(:security_policy_document)
        expect(procurement.errors[:security_policy_document_name].first).to eq 'Enter a security policy document name'
      end
    end

    context 'when considering security_policy_document_version_number' do
      let(:security_policy_document_version_number) { nil }

      it 'is not valid and has the correct error messages' do
        expect(procurement).not_to be_valid(:security_policy_document)
        expect(procurement.errors[:security_policy_document_version_number].first).to eq 'Enter a security policy document version number'
      end
    end

    context 'when considering security_policy_document_date' do
      context 'and it is not a real date' do
        let(:security_policy_document_date_dd) { '29' }
        let(:security_policy_document_date_mm) { '02' }
        let(:security_policy_document_date_yyyy) { '2021' }

        it 'is not valid and has the correct error messages' do
          expect(procurement).not_to be_valid(:security_policy_document)
          expect(procurement.errors[:security_policy_document_date].first).to eq 'The selected date is not valid'
        end
      end
    end

    context 'when considering the file content' do
      context 'and the content types are valid' do
        [['application/pdf', 'pdf'], ['application/msword', 'doc'], ['application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'docx']].each do |content_type, extension|
          let(:content_type) { content_type }
          let(:extension) { extension }

          it 'is valid' do
            expect(procurement).to be_valid(:security_policy_document)
          end
        end
      end

      context 'and the content types are not valid' do
        [['text/plain', 'txt'], ['text/xml', 'xml'], ['image/png', 'png']].each do |content_type, extension|
          let(:content_type) { content_type }
          let(:extension) { extension }

          it 'is not valid' do
            expect(procurement).not_to be_valid(:security_policy_document)
          end
        end
      end
    end
  end

  describe '.start_further_competition' do
    context 'when the procurement transitions to Further Competition' do
      before do
        procurement.update(aasm_state: 'results')
        procurement.start_further_competition!
        procurement.reload
      end

      it 'updates the contract state' do
        expect(procurement.further_competition?).to be true
      end

      it 'adds the contract number' do
        expect(procurement.contract_number).to be_present
      end

      it 'adds the contract date time' do
        expect(procurement.contract_datetime).to be_present
      end
    end
  end

  describe 'valid on contract_details' do
    let(:payment_method) { 'bacs' }
    let(:using_buyer_detail_for_invoice_details) { true }
    let(:using_buyer_detail_for_authorised_detail) { true }
    let(:using_buyer_detail_for_notices_detail) { true }
    let(:security_policy_document_required) { false }
    let(:local_government_pension_scheme) { false }
    let(:governing_law) { 'english' }

    before do
      procurement.payment_method = payment_method
      procurement.using_buyer_detail_for_invoice_details = using_buyer_detail_for_invoice_details
      procurement.using_buyer_detail_for_authorised_detail = using_buyer_detail_for_authorised_detail
      procurement.using_buyer_detail_for_notices_detail = using_buyer_detail_for_notices_detail
      procurement.security_policy_document_required = security_policy_document_required
      procurement.local_government_pension_scheme = local_government_pension_scheme
      procurement.governing_law = governing_law
    end

    context 'when no contact details hve been answered' do
      let(:payment_method) { nil }
      let(:using_buyer_detail_for_invoice_details) { nil }
      let(:using_buyer_detail_for_authorised_detail) { nil }
      let(:using_buyer_detail_for_notices_detail) { nil }
      let(:security_policy_document_required) { nil }
      let(:local_government_pension_scheme) { nil }
      let(:governing_law) { nil }

      it 'will not be valid and have the correct error messages' do
        expect(procurement).not_to be_valid(:contract_details)
        expect(procurement.errors.full_messages).to contain_exactly('Payment method You must answer the question about ‘Payment method’', 'Using buyer detail for invoice details You must answer the question about ‘Invoicing contact details’', 'Using buyer detail for authorised detail You must answer the question about ‘Authorised representative details’', 'Using buyer detail for notices detail You must answer the question about ‘Notices contact details’', 'Security policy document required You must answer the question about ‘Security policy’', 'Local government pension scheme You must answer the question about ‘Local Government Pension Scheme’', 'Governing law You must answer the question about ‘Governing law’')
      end
    end

    context 'when some of the contact details have been answered' do
      let(:using_buyer_detail_for_invoice_details) { nil }
      let(:using_buyer_detail_for_authorised_detail) { nil }
      let(:using_buyer_detail_for_notices_detail) { nil }

      it 'will not be valid and have the correct error messages' do
        expect(procurement).not_to be_valid(:contract_details)
        expect(procurement.errors.full_messages).to contain_exactly('Using buyer detail for invoice details You must answer the question about ‘Invoicing contact details’', 'Using buyer detail for authorised detail You must answer the question about ‘Authorised representative details’', 'Using buyer detail for notices detail You must answer the question about ‘Notices contact details’')
      end
    end

    context 'when all contact details hve been answered' do
      it 'will be valid' do
        expect(procurement).to be_valid(:contract_details)
      end
    end
  end
end
