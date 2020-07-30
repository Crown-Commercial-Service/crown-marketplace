require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurement, type: :model do
  subject(:procurement) { create(:facilities_management_procurement_detailed_search, user: user) }

  let(:user) { create(:user) }

  let(:current_year) { Date.current.year.to_s }
  let(:time) { Time.now.getlocal }
  let(:contract_datetime_value) { "#{time.strftime('%d/%m/%Y')} - #{time.strftime('%l:%M%P')}" }
  let(:da_current_year_1) { create(:facilities_management_procurement_direct_award, contract_number: "RM3860-DA0001-#{current_year}") }
  let(:da_current_year_2) { create(:facilities_management_procurement_direct_award, contract_number: "RM3860-DA0002-#{current_year}") }
  let(:da_previous_year_1) { create(:facilities_management_procurement_direct_award, contract_number: 'RM3860-DA0003-2019') }
  let(:da_previous_year_2) { create(:facilities_management_procurement_direct_award, contract_number: 'RM3860-DA0004-2019') }
  let(:fc_current_year_1) { create(:facilities_management_procurement_further_competition, contract_number: "RM3860-FC0005-#{current_year}", contract_datetime: contract_datetime_value) }
  let(:fc_current_year_2) { create(:facilities_management_procurement_further_competition, contract_number: "RM3860-FC0006-#{current_year}", contract_datetime: contract_datetime_value) }
  let(:fc_previous_year_1) { create(:facilities_management_procurement_further_competition, contract_number: 'RM3860-FC0007-2019', contract_datetime: contract_datetime_value) }
  let(:fc_previous_year_2) { create(:facilities_management_procurement_further_competition, contract_number: 'RM3860-FC0008-2019', contract_datetime: contract_datetime_value) }

  before do
    da_current_year_1
    da_current_year_2
    da_previous_year_1
    da_previous_year_2
    fc_current_year_1
    fc_current_year_2
    fc_previous_year_1
    fc_previous_year_2
  end

  it { is_expected.to be_valid }

  describe '.used_further_competition_contract_numbers_for_current_year' do
    it 'presents all of the further competition contract numbers used for the current year' do
      expect(described_class.used_further_competition_contract_numbers_for_current_year.sort).to match(['0005', '0006'])
    end

    it 'does not present any of the further competition contract numbers used for the previous years' do
      expect(described_class.used_further_competition_contract_numbers_for_current_year.sort).not_to match(['0007', '0008'])
    end
  end

  describe '.generate_contract_number' do
    let(:further_competition) { create(:facilities_management_procurement_further_competition) }
    let(:number_array) { (1..9999).map { |integer| format('%04d', integer % 10000) } }
    let(:expected_number) { number_array.sample }

    before do
      allow(described_class).to receive(:used_further_competition_contract_numbers_for_current_year) { number_array - [expected_number] }
    end

    context 'with a procurement in further_competition' do
      it 'returns an available number for a further_competition contract' do
        expect(further_competition.send(:generate_contract_number_fc)).to eq("RM3830-FC#{expected_number}-#{current_year}")
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_one(:authorised_contact_detail).class_name('FacilitiesManagement::ProcurementAuthorisedContactDetail') }
    it { is_expected.to have_one(:notices_contact_detail).class_name('FacilitiesManagement::ProcurementNoticesContactDetail') }
    it { is_expected.to have_one(:invoice_contact_detail).class_name('FacilitiesManagement::ProcurementInvoiceContactDetail') }
    it { is_expected.to validate_content_type_of(:security_policy_document_file).allowing('application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document') }
    it { is_expected.to validate_content_type_of(:security_policy_document_file).rejecting('text/plain', 'text/xml', 'image/png') }
  end

  describe '#contract_name' do
    context 'when the name is more than 100 characters' do
      it 'is expected to not be valid' do
        procurement.contract_name = (0...101).map { ('a'..'z').to_a[rand(26)] }.join
        expect(procurement.valid?(:contract_name)).to eq false
      end
    end

    context 'when the name is blank' do
      it 'is expected to not be valid' do
        procurement.contract_name = ''
        expect(procurement.valid?(:contract_name)).to eq false
      end
    end

    context 'when the name is correct' do
      it 'expected to be valid' do
        procurement.contract_name = 'Valid Name'
        expect(procurement.valid?(:contract_name)).to eq true
      end
    end
  end

  describe '#estimated_annual_cost' do
    context 'when estimated_cost_known is true' do
      context 'when estimated_annual_cost is present' do
        it 'expected to be valid' do
          procurement.estimated_cost_known = true
          procurement.estimated_annual_cost = 25000
          expect(procurement.valid?(:estimated_annual_cost)).to eq true
        end
      end

      context 'when the estimated_annual_cost is not present' do
        it 'expected to not be valid' do
          procurement.estimated_cost_known = true
          expect(procurement.valid?(:estimated_annual_cost)).to eq false
        end
      end
    end

    context 'when estimated_cost_known is false' do
      context 'when estimated_annual_cost is present' do
        it 'expected to be valid' do
          procurement.estimated_cost_known = false
          procurement.estimated_annual_cost = 25000
          expect(procurement.valid?(:estimated_annual_cost)).to eq true
        end
      end

      context 'when the estimated_annual_cost is not present' do
        it 'expected to be valid' do
          procurement.estimated_cost_known = false
          expect(procurement.valid?(:estimated_annual_cost)).to eq true
        end
      end
    end
  end

  describe '#payment_method' do
    context 'when a payment_method is not present' do
      it 'is expected not to be valid' do
        procurement.payment_method = ''
        expect(procurement.valid?(:payment_method)).to eq false
      end
    end

    context 'when bacs is a selected payment_method' do
      it 'is expected to be valid' do
        procurement.payment_method = 'bacs'
        expect(procurement.valid?(:payment_method)).to eq true
      end
    end

    context 'when card is a selected payment_method' do
      it 'is expected to be valid' do
        procurement.payment_method = 'card'
        expect(procurement.valid?(:payment_method)).to eq true
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
        expect(procurement.valid?(:procurement_buildings)).to eq false
      end
    end

    context 'when there are no active procurement_buildings on the procurement_buildings step' do
      it 'expected to be invalid' do
        procurement.procurement_buildings.first.update(active: false)
        expect(procurement.valid?(:procurement_buildings)).to eq false
      end
    end

    context 'when there is an active procurement_building on the procurement_buildings step' do
      it 'expected to be valid' do
        procurement.save
        procurement.procurement_buildings.create(active: true)
        expect(procurement.valid?(:procurement_buildings)).to eq true
      end
    end

    # rubocop:disable Rails/SkipsModelValidations
    context 'when the procurement_building is present with a service code' do
      it 'expected to be valid' do
        procurement.save
        procurement.procurement_buildings.create
        procurement.procurement_buildings.first.update_column(:service_codes, ['test'])
        expect(procurement.valid?(:building_services)).to eq true
      end
    end
    # rubocop:enable Rails/SkipsModelValidations

    context 'when the procurement_building is present but without any service codes' do
      it 'expected to not be valid' do
        procurement.save
        procurement_building = procurement.procurement_buildings.create(active: true)
        allow(procurement_building.building).to receive(:building_name).and_return('asa')
        expect(procurement_building.valid?(:building_services)).to eq false
      end
    end
  end

  describe '#find_or_build_procurement_building' do
    let(:building_data) do
      {
        'name' => 'test',
        'address' => {
          'fm-address-line-1' => 'line 1',
          'fm-address-line-2' => 'line 2',
          'fm-address-town' => 'town',
          'fm-address-county' => 'county',
          'fm-address-postcode' => 'postcode'
        }
      }
    end

    let(:building_id) { SecureRandom.uuid }

    context 'when procurement building already exists' do
      before do
        procurement.save
        procurement.procurement_buildings.create(building_id: building_id)
      end

      it 'does not create a new one' do
        expect { procurement.find_or_build_procurement_building(building_id) }.not_to change(FacilitiesManagement::ProcurementBuilding, :count)
      end
    end

    context 'when procurement building does not exist' do
      it 'creates one' do
        procurement.save
        expect { procurement.find_or_build_procurement_building(building_id) }.to change(FacilitiesManagement::ProcurementBuilding, :count).by(1)
      end

      it 'has the services already on it' do
        procurement.save
        procurement.find_or_build_procurement_building(building_id)
        expect(procurement.procurement_buildings.last.service_codes).to eq procurement.service_codes
      end
    end

    context 'when the procurement building does exists' do
      it 'does not change the service codes when they are updated on the procurement' do
        procurement.save
        procurement.find_or_build_procurement_building(building_id)
        procurement.service_codes << 'C.5'
        procurement.save
        expect { procurement.find_or_build_procurement_building(building_id) }.not_to change(procurement.procurement_buildings.last.service_codes, :count)
      end
    end
  end

  describe 'validations on :all' do
    before { procurement.initial_call_off_start_date = DateTime.now.in_time_zone('London') + 1.day }

    context 'when the contract name is blank' do
      it 'is expected to not be valid' do
        procurement.contract_name = ''
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the estimated_annual_cost is blank' do
      it 'is expected to not be valid' do
        procurement.estimated_cost_known = nil
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the tupe is blank' do
      it 'is expected to not be valid' do
        procurement.tupe = nil
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the initial_call_off_period is blank' do
      it 'is expected to not be valid' do
        procurement.initial_call_off_period = nil
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the initial_call_off_period is blank' do
      it 'is expected to not be valid' do
        procurement.initial_call_off_period = nil
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the initial_call_off_period is blank' do
      it 'is expected to not be valid' do
        procurement.initial_call_off_period = nil
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the tupe is selected and mobilisation length is less than 4 weeks' do
      it 'is expected to not be valid' do
        procurement.tupe = true
        procurement.mobilisation_period_required = true
        procurement.mobilisation_period = 3
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the tupe is selected and mobilisation length is more than 4 weeks' do
      it 'is expected to be valid' do
        procurement.tupe = true
        procurement.mobilisation_period = 5
        expect(procurement.valid?(:all)).to eq true
      end
    end

    context 'when the there are no procurement buildings' do
      it 'is expected not to be valid' do
        procurement.procurement_buildings.destroy_all
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the there is a procurement building but no procurement_building_services' do
      it 'is expected not to be valid' do
        procurement.procurement_buildings.first.procurement_building_services.destroy_all
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the there is a procurement building with two procurement_building_services' do
      it 'is expected to be valid' do
        expect(procurement.valid?(:all)).to eq true
      end
    end
  end

  describe '#valid_on_continue?' do
    context 'when valid on all' do
      it 'is expected to return false' do
        expect(procurement.valid_on_continue?).to eq false
      end
    end
  end

  describe '#valid_on_continue' do
    context 'when valid on all' do
      it 'is expected to return true' do
        procurement.save
        expect(procurement.valid_on_continue?).to eq false
      end
    end

    context 'when procurement not valid' do
      it 'is expected to return false' do
        procurement.initial_call_off_period = nil
        expect(procurement.valid_on_continue?).to eq false
      end
    end

    context 'when procurement_building does not have procurement_building_services' do
      it 'is expected to return false' do
        procurement.procurement_buildings.first.procurement_building_services.destroy_all
        expect(procurement.valid_on_continue?).to eq false
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
        procurement_building = create(:facilities_management_procurement_building, procurement: procurement, service_codes: ['C.5', 'E.4', 'K.8'])
        expect(procurement.procurement_buildings.requires_service_information).to eq [procurement_building]
      end
    end

    context 'when a building has no services that require questions' do
      it 'is not in the array' do
        procurement_building = create(:facilities_management_procurement_building, procurement: procurement, service_codes: ['K.11', 'K.14', 'K.8'])
        expect(procurement.procurement_buildings.requires_service_information).not_to eq [procurement_building]
      end
    end

    context 'when a building has a service that require questions' do
      it 'is in the array' do
        procurement_building = create(:facilities_management_procurement_building, procurement: procurement, service_codes: ['K.7'])
        expect(procurement.procurement_buildings.requires_service_information).to eq [procurement_building]
      end
    end

    context 'when a building has no services' do
      it 'is not in the array' do
        procurement_building = create(:facilities_management_procurement_building, procurement: procurement, service_codes: [])
        expect(procurement.procurement_buildings.requires_service_information).not_to eq [procurement_building]
      end
    end
  end

  describe '#set_state_to_results_if_possible' do
    let(:supplier_uuid) { 'eb7b05da-e52e-46a3-99ae-2cb0e6226232' }
    let(:da_value_test) { 865.2478374540002 }
    let(:da_value_test1) { 1517.20280381278 }
    let(:obj) { double }

    before do
      allow(CCS::FM::Supplier.supplier_name('any')).to receive(:id).and_return(supplier_uuid)
      allow(FacilitiesManagement::AssessedValueCalculator).to receive(:new).with(procurement.id).and_return(obj)
      allow(obj).to receive(:assessed_value).and_return(0.1234)
      allow(obj).to receive(:lot_number).and_return('1a')
      allow(obj).to receive(:sorted_list).and_return([[:test, da_value_test], [:test1, da_value_test1]])
    end

    context 'when no eligible suppliers' do
      it 'does not create any procurement suppliers' do
        allow(obj).to receive(:sorted_list).and_return([])
        expect { procurement.set_state_to_results_if_possible }.to change { FacilitiesManagement::ProcurementSupplier.count }.by(0)
      end
    end

    context 'when some eligible suppliers' do
      it 'creates procurement_suppliers' do
        expect { procurement.set_state_to_results_if_possible }.to change { FacilitiesManagement::ProcurementSupplier.count }.by(2)
      end
      it 'creates procurement_suppliers with the right direct award value' do
        procurement.set_state_to_results_if_possible
        expect(procurement.procurement_suppliers.first.direct_award_value).to eq da_value_test
        expect(procurement.procurement_suppliers.last.direct_award_value).to eq da_value_test1
      end
      it 'creates procurement_suppliers with the right CCS::FM::Supplier id' do
        procurement.set_state_to_results_if_possible
        expect(procurement.procurement_suppliers.first.supplier_id).to eq supplier_uuid
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
        expect(CCS::FM::FrozenRate.where(facilities_management_procurement_id: procurement.id).size).to eq 155
        expect(CCS::FM::FrozenRateCard.where(facilities_management_procurement_id: procurement.id).size).to eq 1
      end
    end

    describe 'changing state' do
      let(:procurement_building) { create(:facilities_management_procurement_building_no_services, procurement: procurement) }
      let(:estimated_cost_known) { nil }
      let(:services_standard) { nil }

      before do
        procurement.procurement_buildings.destroy_all
        codes.each_with_index do |code, index|
          create(:facilities_management_procurement_building_service, code: code, service_standard: services_standard[index], procurement_building: procurement_building)
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
          expect(procurement.lot_number).to be nil
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
          expect(procurement.lot_number).to be nil
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
          expect(procurement.lot_number).not_to be nil
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
          expect(procurement.lot_number).not_to be nil
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
          expect(procurement.lot_number).not_to be nil
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
          expect(procurement.lot_number).not_to be nil
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
          expect(procurement.lot_number).not_to be nil
        end

        it 'procurement_building_services_not_used_in_calculation an empty list' do
          expect(procurement.procurement_building_services_not_used_in_calculation.size).to eq 0
        end
      end

      context 'when customer has some services unpriced and when buyer input present' do
        let(:codes) { %w[G.1 L.7 L.8] }
        let(:services_standard) { [nil, nil, nil] }
        let(:estimated_cost_known) { true }

        it 'some_services_unpriced_and_no_buyer_input? returns false' do
          expect(procurement.some_services_unpriced_and_no_buyer_input?).to be false
        end

        it 'does save lot number' do
          expect(procurement.lot_number).not_to be nil
        end
      end
    end

    describe '#offer_to_next_supplier' do
      let(:da_value_test) { 500 }
      let(:da_value_test1) { 1500 }
      let(:da_value_test2) { 1000 }
      let(:da_value_test3) { 2000 }

      before do
        allow(obj).to receive(:sorted_list).and_return([[:test, da_value_test2], [:test1, da_value_test], [:test2, da_value_test3], [:test3, da_value_test1]])
        allow(FacilitiesManagement::GenerateContractZip).to receive(:perform_in).and_return(nil)
        allow(FacilitiesManagement::ChangeStateWorker).to receive(:perform_at).and_return(nil)
        allow(FacilitiesManagement::ContractSentReminder).to receive(:perform_at).and_return(nil)
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(FacilitiesManagement::ProcurementSupplier).to receive(:send_email_to_supplier).and_return(nil)
        allow_any_instance_of(FacilitiesManagement::ProcurementSupplier).to receive(:send_email_to_buyer).and_return(nil)
        # rubocop:enable RSpec/AnyInstance
        procurement.set_state_to_results_if_possible
        procurement.aasm_state = 'direct_award'
        procurement.save
      end

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
          expect(closed_contracts.all?('sent')).to eq true
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
  end

  describe '#priced_at_framework' do
    context 'when one of the services is not priced at framework' do
      before do
        procurement.procurement_building_services.first.update(code: 'C.1', service_standard: 'A')
        procurement.procurement_building_services.last.update(code: 'C.2', service_standard: 'C')
      end

      it 'returns false' do
        expect(procurement.send(:priced_at_framework)).to eq false
      end
    end

    context 'when all services are priced at framework' do
      before do
        procurement.procurement_building_services.first.update(code: 'C.1', service_standard: 'A')
        procurement.procurement_building_services.last.update(code: 'C.2', service_standard: 'A')
      end

      it 'returns true' do
        expect(procurement.send(:priced_at_framework)).to eq true
      end
    end
  end

  describe '#direct_award?' do
    context 'when the procurement is set to direct award' do
      it 'is expected to be true' do
        procurement.aasm_state = 'direct_award'

        expect(procurement.direct_award?).to eq(true)
      end
    end

    context 'when the procurement is not set to direct award' do
      it 'is expected to be false' do
        expect(procurement.direct_award?).to eq(false)
      end
    end
  end

  describe 'extension periods start and end dates' do
    let(:procurement) { create(:facilities_management_procurement_with_extension_periods) }

    describe '#extension_period_1_start_date' do
      context 'when there is an extension period selected' do
        it 'is expected to return a date after the initial call off period has ended' do
          initial_call_off_period_end_date = procurement.initial_call_off_start_date + procurement.initial_call_off_period.years - 1.day

          expect(procurement.extension_period_1_start_date).to eq(initial_call_off_period_end_date + 1.day)
        end
      end

      context 'when an extension period isn\'t selected' do
        it 'is expected to return nil' do
          procurement.optional_call_off_extensions_1 = nil

          expect(procurement.extension_period_1_start_date).to be_nil
        end
      end
    end

    describe '#extension_period_1_end_date' do
      context 'when there is an extension period selected' do
        it 'is expected to return a date after the initial call off period has ended' do
          extension_2_start_date = procurement.initial_call_off_start_date + (procurement.initial_call_off_period + procurement.optional_call_off_extensions_1).years

          expect(procurement.extension_period_1_end_date).to eq(extension_2_start_date - 1.day)
        end
      end

      context 'when an extension period isn\'t selected' do
        it 'is expected to return nil' do
          procurement.optional_call_off_extensions_1 = nil

          expect(procurement.extension_period_1_end_date).to be_nil
        end
      end
    end

    describe '#extension_period_2_start_date' do
      context 'when there is an extension period selected' do
        it 'is expected to return a date after the first extension period period has ended' do
          expected_years = (procurement.initial_call_off_period + procurement.optional_call_off_extensions_1)
          extension_period_1_end_date = procurement.initial_call_off_start_date + expected_years.years - 1.day

          expect(procurement.extension_period_2_start_date).to eq(extension_period_1_end_date + 1.day)
        end
      end

      context 'when an extension period isn\'t selected' do
        it 'is expected to return nil' do
          procurement.optional_call_off_extensions_2 = nil

          expect(procurement.extension_period_2_start_date).to be_nil
        end
      end
    end

    describe '#extension_period_2_end_date' do
      context 'when there is an extension period selected' do
        it 'is expected to return a date after the first extension period has ended' do
          extension_3_start_date = procurement.initial_call_off_start_date + (procurement.initial_call_off_period + procurement.optional_call_off_extensions_1 + procurement.optional_call_off_extensions_2).years

          expect(procurement.extension_period_2_end_date).to eq(extension_3_start_date - 1.day)
        end
      end

      context 'when an extension period isn\'t selected' do
        it 'is expected to return nil' do
          procurement.optional_call_off_extensions_2 = nil

          expect(procurement.extension_period_2_end_date).to be_nil
        end
      end
    end

    describe '#extension_period_3_start_date' do
      context 'when there is an extension period selected' do
        it 'is expected to return a date after the second extension period period has ended' do
          expected_years = (procurement.initial_call_off_period + procurement.optional_call_off_extensions_1 + procurement.optional_call_off_extensions_2)
          extension_period_2_end_date = procurement.initial_call_off_start_date + expected_years.years - 1.day

          expect(procurement.extension_period_3_start_date).to eq(extension_period_2_end_date + 1.day)
        end
      end

      context 'when an extension period isn\'t selected' do
        it 'is expected to return nil' do
          procurement.optional_call_off_extensions_3 = nil

          expect(procurement.extension_period_3_start_date).to be_nil
        end
      end
    end

    describe '#extension_period_3_end_date' do
      context 'when there is an extension period selected' do
        it 'is expected to return a date after the initial call off period has ended' do
          extension_4_start_date = procurement.initial_call_off_start_date + (procurement.initial_call_off_period + procurement.optional_call_off_extensions_1 + procurement.optional_call_off_extensions_2 + procurement.optional_call_off_extensions_3).years

          expect(procurement.extension_period_3_end_date).to eq(extension_4_start_date - 1.day)
        end
      end

      context 'when an extension period isn\'t selected' do
        it 'is expected to return nil' do
          procurement.optional_call_off_extensions_3 = nil

          expect(procurement.extension_period_3_end_date).to be_nil
        end
      end
    end

    describe '#extension_period_4_start_date' do
      context 'when there is an extension period selected' do
        it 'is expected to return a date after the third extension period has ended' do
          expected_years = (procurement.initial_call_off_period + procurement.optional_call_off_extensions_1 + procurement.optional_call_off_extensions_2 + procurement.optional_call_off_extensions_3)
          extension_period_3_end_date = procurement.initial_call_off_start_date + expected_years.years - 1.day

          expect(procurement.extension_period_4_start_date).to eq(extension_period_3_end_date + 1.day)
        end
      end

      context 'when an extension period isn\'t selected' do
        it 'is expected to return nil' do
          procurement.optional_call_off_extensions_4 = nil

          expect(procurement.extension_period_4_end_date).to be_nil
        end
      end
    end

    describe '#extension_period_4_end_date' do
      context 'when there is an extension period selected' do
        it 'is expected to return a date after the initial call off period has ended' do
          extension_5_start_date = procurement.initial_call_off_start_date + (procurement.initial_call_off_period + procurement.optional_call_off_extensions_1 + procurement.optional_call_off_extensions_2 + procurement.optional_call_off_extensions_3 + procurement.optional_call_off_extensions_4).years

          expect(procurement.extension_period_4_end_date).to eq(extension_5_start_date - 1.day)
        end
      end

      context 'when an extension period isn\'t selected' do
        it 'is expected to return nil' do
          procurement.optional_call_off_extensions_4 = nil

          expect(procurement.extension_period_4_end_date).to be_nil
        end
      end
    end
  end

  describe '#more_than_max_pensions?' do
    let(:pension_fund) { build(:facilities_management_procurement_pension_fund, procurement: create(:facilities_management_procurement)) }
    let(:attributes) { ActiveSupport::HashWithIndifferentAccess.new(pension_fund.attributes) }

    before do
      attributes['percentage'] = attributes['percentage'].to_s
    end

    # validating number of record
    context 'when the number of records is greater than 99' do
      it 'is expected to be true' do
        99.times do
          procurement.procurement_pension_funds.build(attributes)
        end
      end
    end

    describe '#before_each_procurement_pension_funds verify' do
      let(:pension_fund1) { build(:facilities_management_procurement_pension_fund, procurement: create(:facilities_management_procurement)) }
      let(:pension_fund2) { build(:facilities_management_procurement_pension_fund, procurement: create(:facilities_management_procurement)) }

      context 'when the name is not case sensitive' do
        it 'can be saved if name is not case sensitive' do
          pension_fund2.name = pension_fund1.name + 'abc'
          procurement.procurement_pension_funds = [pension_fund1, pension_fund2]
          expect(pension_fund1.case_sensitive_error).to eq false
          expect(pension_fund2.case_sensitive_error).to eq false
        end

        it 'cannot be saved if name is case sensitive' do
          pension_fund2.name = pension_fund1.name.upcase
          expect { procurement.procurement_pension_funds = [pension_fund1, pension_fund2] }.to raise_exception(ActiveRecord::RecordNotSaved)
          expect(pension_fund1.case_sensitive_error).to eq false
          expect(pension_fund2.case_sensitive_error).to eq true
        end
      end
    end

    describe 'further competition verify' do
      context 'when further competition is valid' do
        it 'is expected to be true' do
          procurement.aasm_state = 'further_competition'
          expect(procurement.further_competition?).to eq(true)
        end

        it 'is expected to be false' do
          expect(procurement.further_competition?).to eq(false)
        end
      end

      context 'when contract_datetime format is created' do
        it 'returns value' do
          expect(fc_current_year_1.contract_datetime).to eq contract_datetime_value
        end
      end
    end
  end

  describe 'services missing prices' do
    let(:procurement_building) { create(:facilities_management_procurement_building_no_services, procurement: procurement) }

    before do
      procurement.procurement_buildings.destroy_all
      codes.each do |code|
        create(:facilities_management_procurement_building_service, code: code, procurement_building: procurement_building)
      end
      procurement.update(estimated_cost_known: estimated_cost_known)
    end

    context 'when buyer input not present' do
      let(:estimated_cost_known) { false }

      context 'when all services are missing FW & BM prices' do
        let(:codes) { %w[L.6 L.7 L.8] }

        it 'all_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)). to eq true
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)). to eq true
        end

        it 'all_services_missing_framework_and_benchmark_price? returns true' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)). to eq true
        end
      end

      context 'when all but one service missing FW price' do
        let(:codes) { %w[G.1 G.2 D.6] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)). to eq false
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)). to eq false
        end

        it 'all_services_missing_framework_and_benchmark_price? returns false' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)). to eq false
        end
      end

      context 'when all but one service missing BM and FW price' do
        let(:codes) { %w[G.1 G.2 L.6] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)). to eq false
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)). to eq true
        end

        it 'all_services_missing_framework_and_benchmark_price? returns false' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)). to eq false
        end
      end

      context 'when the services include unused services and one unpriced service' do
        let(:codes) { %w[D.3 M.1 O.1] }

        it 'all_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)). to eq true
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)). to eq true
        end

        it 'all_services_missing_framework_and_benchmark_price? returns true' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)). to eq true
        end
      end

      context 'when the services include the two unused services and one priced service' do
        let(:codes) { %w[C.1 M.1 N.1] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)). to eq false
        end

        it 'some_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)). to eq false
        end

        it 'all_services_missing_framework_and_benchmark_price? returns false' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)). to eq false
        end
      end

      context 'when all the services are priced' do
        let(:codes) { %w[C.1 C.2 C.3] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)). to eq false
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)). to eq false
        end

        it 'all_services_missing_framework_and_benchmark_price? returns false' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)). to eq false
        end
      end
    end

    context 'when buyer input present' do
      let(:estimated_cost_known) { true }

      context 'when all services are missing FW & BM prices' do
        let(:codes) { %w[L.6 L.7 L.8] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)). to eq false
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)). to eq false
        end

        it 'all_services_missing_framework_and_benchmark_price? returns true' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)). to eq true
        end
      end

      context 'when all but one service missing FW price' do
        let(:codes) { %w[G.1 G.2 D.6] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)). to eq false
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)). to eq false
        end

        it 'all_services_missing_framework_and_benchmark_price? returns false' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)). to eq false
        end
      end

      context 'when all but one service missing BM and FW price' do
        let(:codes) { %w[G.1 G.2 L.6] }

        it 'all_services_unpriced_and_no_buyer_input returns false' do
          expect(procurement.send(:all_services_unpriced_and_no_buyer_input?)). to eq false
        end

        it 'some_services_unpriced_and_no_buyer_input returns true' do
          expect(procurement.send(:some_services_unpriced_and_no_buyer_input?)). to eq false
        end

        it 'all_services_missing_framework_and_benchmark_price? returns false' do
          expect(procurement.send(:all_services_missing_framework_and_benchmark_price?)). to eq false
        end
      end
    end
  end

  describe '#set_state_to_results' do
    let(:procurement) { create(:facilities_management_procurement_for_further_competition, aasm_state: state) }
    let(:building) { create :facilities_management_building_london }

    before do
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

  describe '.valid_buildings?' do
    context 'when the building is missing gia' do
      it 'is not valid' do
        procurement.active_procurement_buildings.first.update(service_codes: ['C.1'])
        procurement.active_procurement_buildings.first.building.update(gia: 0)
        expect(procurement.send(:valid_buildings?)).to eq false
      end
    end

    context 'when the building is missing external_area' do
      it 'is not valid' do
        procurement.active_procurement_buildings.first.update(service_codes: ['G.5'])
        procurement.active_procurement_buildings.first.building.update(external_area: 0)
        expect(procurement.send(:valid_buildings?)).to eq false
      end
    end

    context 'when the building is not missing gia or external_area' do
      it 'is valid' do
        procurement.active_procurement_buildings.first.update(service_codes: ['C.1', 'G.5'])
        expect(procurement.send(:valid_buildings?)).to eq true
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
end
