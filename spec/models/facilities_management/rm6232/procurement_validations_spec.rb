require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Procurement do
  describe 'validations' do
    describe 'contract_name' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next, user:) }
      let(:user) { create(:user) }

      before { procurement.contract_name = contract_name }

      context 'when the name is more than 100 characters' do
        let(:contract_name) { (0...101).map { ('a'..'z').to_a.sample }.join }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:contract_name].first).to eq 'Your contract name must be 100 characters or fewer'
        end
      end

      context 'when the name is nil' do
        let(:contract_name) { nil }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:contract_name].first).to eq 'Enter your contract name'
        end
      end

      context 'when the name is empty' do
        let(:contract_name) { '' }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:contract_name].first).to eq 'Enter your contract name'
        end
      end

      context 'when the name is taken by the same user' do
        let(:contract_name) { 'My taken name' }

        it 'is expected to not be valid and has the correct error message' do
          create(:facilities_management_rm6232_procurement_what_happens_next, user:, contract_name:)

          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:contract_name].first).to eq 'This contract name is already in use'
        end
      end

      context 'when the name is taken by the a different user' do
        let(:contract_name) { 'My taken name' }

        it 'is valid' do
          create(:facilities_management_rm6232_procurement_what_happens_next, user: create(:user), contract_name: contract_name)

          expect(procurement.valid?(:contract_name)).to be true
        end
      end

      context 'when the name is correct' do
        let(:contract_name) { 'Valid Name' }

        it 'expected to be valid' do
          expect(procurement.valid?(:contract_name)).to be true
        end
      end
    end

    describe 'requirements_linked_to_pfi' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next, user:) }
      let(:user) { create(:user) }

      before { procurement.requirements_linked_to_pfi = requirements_linked_to_pfi }

      context 'when requirements_linked_to_pfi is nil' do
        let(:requirements_linked_to_pfi) { nil }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:requirements_linked_to_pfi].first).to eq 'Select one option for requirements linked to PFI'
        end
      end

      context 'when the requirements_linked_to_pfi is empty' do
        let(:requirements_linked_to_pfi) { '' }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:requirements_linked_to_pfi].first).to eq 'Select one option for requirements linked to PFI'
        end
      end

      [true, false].each do |option|
        context "when the requirements_linked_to_pfi is #{option}" do
          let(:requirements_linked_to_pfi) { option }

          it 'expected to be valid' do
            expect(procurement.valid?(:contract_name)).to be true
          end
        end
      end
    end

    describe 'annual_contract_value' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_entering_requirements, annual_contract_value:) }

      context 'when no annual contract cost is present' do
        let(:annual_contract_value) { nil }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:annual_contract_value)).to be false
          expect(procurement.errors[:annual_contract_value].first).to eq 'The annual contract cost must be a whole number greater than 0'
        end
      end

      context 'when the annual contract cost is not a number' do
        let(:annual_contract_value) { 'Camuvari' }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:annual_contract_value)).to be false
          expect(procurement.errors[:annual_contract_value].first).to eq 'The annual contract cost must be a whole number greater than 0'
        end
      end

      context 'when the annual contract cost is not an integer' do
        let(:annual_contract_value) { 1_000_000.67 }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:annual_contract_value)).to be false
          expect(procurement.errors[:annual_contract_value].first).to eq 'The annual contract cost must be a whole number greater than 0'
        end
      end

      context 'when the annual contract cost is less than 1' do
        let(:annual_contract_value) { 0 }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:annual_contract_value)).to be false
          expect(procurement.errors[:annual_contract_value].first).to eq 'The annual contract cost must be a whole number greater than 0'
        end
      end

      context 'when the annual contract cost is more than 999,999,999,999' do
        let(:annual_contract_value) { 1_000_000_000_000 }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:annual_contract_value)).to be false
          expect(procurement.errors[:annual_contract_value].first).to eq 'The annual contract cost must be less than 1,000,000,000,000 (1 trillion)'
        end
      end

      context 'when annual contract cost is present' do
        let(:annual_contract_value) { 123_456 }

        it 'is valid' do
          expect(procurement.valid?(:annual_contract_value)).to be true
        end
      end
    end

    describe 'tupe' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_entering_requirements, tupe:) }

      context 'when it is blank' do
        let(:tupe) { '' }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:tupe)).to be false
          expect(procurement.errors[:tupe].first).to eq 'Select one option'
        end
      end

      context 'when it is nil' do
        let(:tupe) { nil }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:tupe)).to be false
          expect(procurement.errors[:tupe].first).to eq 'Select one option'
        end
      end

      context 'when it is a string' do
        let(:tupe) { 'I am a string' }

        it 'is valid as it evaluates to truthy' do
          expect(procurement.valid?(:tupe)).to be true
        end
      end

      context 'when it is true' do
        let(:tupe) { true }

        it 'is valid' do
          expect(procurement.valid?(:tupe)).to be true
        end
      end

      context 'when it is false' do
        let(:tupe) { false }

        it 'is valid' do
          expect(procurement.valid?(:tupe)).to be true
        end
      end
    end

    describe 'services' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_entering_requirements, service_codes:) }

      context 'when no service codes are present' do
        let(:service_codes) { [] }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:services)).to be false
          expect(procurement.errors[:service_codes].first).to eq 'Select at least one service you need to include in your procurement'
        end
      end

      # rubocop:disable RSpec/NestedGroups
      context 'when validating that not all services are mandatory' do
        context 'when the only code is Q.3' do
          let(:service_codes) { %w[Q.3] }

          it 'is not valid and has the correct error message' do
            expect(procurement.valid?(:services)).to be false
            expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
          end
        end

        context 'when the only code is R.1' do
          let(:service_codes) { %w[R.1] }

          it 'is not valid and has the correct error message' do
            expect(procurement.valid?(:services)).to be false
            expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
          end
        end

        context 'when the only code is S.1' do
          let(:service_codes) { %w[S.1] }

          it 'is not valid and has the correct error message' do
            expect(procurement.valid?(:services)).to be false
            expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
          end
        end

        context 'when the only codes are Q.3 and R.1' do
          let(:service_codes) { %w[Q.3 R.1] }

          it 'is not valid and has the correct error message' do
            expect(procurement.valid?(:services)).to be false
            expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
          end
        end

        context 'when the only codes are Q.3 and S.1' do
          let(:service_codes) { %w[Q.3 S.1] }

          it 'is not valid and has the correct error message' do
            expect(procurement.valid?(:services)).to be false
            expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
          end
        end

        context 'when the only codes are S.1 and R.1' do
          let(:service_codes) { %w[S.1 R.1] }

          it 'is not valid and has the correct error message' do
            expect(procurement.valid?(:services)).to be false
            expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
          end
        end

        context 'when the only codes are Q.3, S.1 and R.1' do
          let(:service_codes) { %w[Q.3 S.1 R.1] }

          it 'is not valid and has the correct error message' do
            expect(procurement.valid?(:services)).to be false
            expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
          end
        end
      end
      # rubocop:enable RSpec/NestedGroups

      context 'when service codes are present' do
        let(:service_codes) { %w[E.1 Q.3 S.1 R.1] }

        it 'is valid' do
          expect(procurement.valid?(:services)).to be true
        end
      end
    end

    describe 'procurement buildings' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_entering_requirements) }

      context 'when there are no procurement buildings' do
        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:buildings)).to be false
          expect(procurement.errors[:procurement_buildings].first).to eq 'Select at least one building'
        end
      end

      context 'when there are procurement buildings but none are active' do
        before { procurement.procurement_buildings.build(procurement: procurement, building: create(:facilities_management_building), active: false) }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:buildings)).to be false
          expect(procurement.errors[:procurement_buildings].first).to eq 'Select at least one building'
        end
      end

      context 'when there are procurement buildings and some are active' do
        before { procurement.procurement_buildings.build(procurement: procurement, building: create(:facilities_management_building), active: true) }

        it 'is valid' do
          expect(procurement.valid?(:buildings)).to be true
        end
      end
    end

    describe '.contract_period_in_past?' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_entering_requirements, initial_call_off_start_date:) }

      context 'when initial call off period is in the past' do
        let(:initial_call_off_start_date) { Time.now.in_time_zone('London') - 10.days }

        it 'returns true' do
          expect(procurement.send(:contract_period_in_past?)).to be true
        end
      end

      context 'when initial call off period is not in the past' do
        let(:initial_call_off_start_date) { Time.now.in_time_zone('London') + 10.days }

        it 'returns false' do
          expect(procurement.send(:contract_period_in_past?)).to be false
        end
      end
    end

    describe '.mobilisation_period_in_past?' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_entering_requirements, initial_call_off_start_date: Time.now.in_time_zone('London') + 5.weeks, mobilisation_period_required: true, mobilisation_period: mobilisation_period) }

      context 'when mobilisation period is in the past' do
        let(:mobilisation_period) { 10 }

        it 'returns true' do
          expect(procurement.send(:mobilisation_period_in_past?)).to be true
        end
      end

      context 'when mobilisation period is not in the past' do
        let(:mobilisation_period) { 4 }

        it 'returns false' do
          expect(procurement.send(:mobilisation_period_in_past?)).to be false
        end
      end
    end

    # rubocop:disable RSpec/NestedGroups
    describe '.mobilisation_period_valid_when_tupe_required?' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_entering_requirements, tupe:, mobilisation_period_required:, mobilisation_period:) }
      let(:mobilisation_period_required) { false }
      let(:mobilisation_period) { 4 }

      context 'when tupe is true' do
        let(:tupe) { true }

        context 'when mobilisation period required is false' do
          it 'returns false' do
            expect(procurement.send(:mobilisation_period_valid_when_tupe_required?)).to be false
          end
        end

        context 'when mobilisation period required is true and is 3 weeks' do
          let(:mobilisation_period_required) { true }
          let(:mobilisation_period) { 3 }

          it 'returns false' do
            expect(procurement.send(:mobilisation_period_valid_when_tupe_required?)).to be false
          end
        end

        context 'when mobilisation period required is true and is 4 weeks' do
          let(:mobilisation_period_required) { true }
          let(:mobilisation_period) { 4 }

          it 'returns true' do
            expect(procurement.send(:mobilisation_period_valid_when_tupe_required?)).to be true
          end
        end
      end

      context 'when tupe is false' do
        let(:tupe) { false }

        it 'returns true' do
          expect(procurement.send(:mobilisation_period_valid_when_tupe_required?)).to be true
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end

    describe 'validations on entering_requirements' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, user:) }
      let(:building) { create(:facilities_management_building, user:) }
      let(:user) { create(:user) }

      context 'with valid scenarios' do
        before { procurement.procurement_buildings.create(building_id: building.id, service_codes: ['E.1'], active: true) }

        it 'returns true' do
          expect(procurement.valid?(:entering_requirements)).to be true
        end
      end

      # rubocop:disable RSpec/NestedGroups
      context 'with invalid scenarios' do
        let(:continue_error_list) { procurement.errors.details[:base].map.with_index { |detail, index| [detail[:error], procurement.errors[:base][index]] }.to_h }

        context 'when all statuses are not_started or cannot_start' do
          before do
            %i[tupe initial_call_off_period_years initial_call_off_period_months initial_call_off_start_date mobilisation_period_required extensions_required].each do |attribute|
              procurement[attribute] = nil
            end
            procurement.service_codes = []
            procurement.save
            procurement.valid?(:entering_requirements)
          end

          it 'is not valid' do
            expect(procurement.errors.any?).to be true
          end

          it 'has the correct errors' do
            expected_error_list = {
              tupe_incomplete: '‘TUPE’ must be ‘COMPLETED’',
              contract_period_incomplete: '‘Contract period’ must be ‘COMPLETED’',
              services_incomplete: '‘Services’ must be ‘COMPLETED’',
              buildings_incomplete: '‘Buildings’ must be ‘COMPLETED’',
              buildings_and_services_incomplete: '‘Assigning services to buildings’ must be ‘COMPLETED’'
            }

            expect(continue_error_list).to eq expected_error_list
          end
        end

        context 'when all other statuses are completed and buildings_and_services is incomplete' do
          before do
            procurement.procurement_buildings.create(building_id: building.id, active: true)
            procurement.valid?(:entering_requirements)
          end

          it 'is not valid' do
            expect(procurement.errors.any?).to be true
          end

          it 'has the correct errors' do
            expected_error_list = {
              buildings_and_services_incomplete: '‘Assigning services to buildings’ must be ‘COMPLETED’'
            }

            expect(continue_error_list).to eq expected_error_list
          end
        end

        context 'when all services are added' do
          before { procurement.procurement_buildings.create(building_id: building.id, service_codes: procurement.service_codes, active: true) }

          context 'and initial call off start date is in the past' do
            before do
              procurement.update(initial_call_off_start_date: Time.now.in_time_zone('London') - 10.days, mobilisation_period_required: false)
              procurement.valid?(:entering_requirements)
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
              procurement.update(initial_call_off_start_date: Time.now.in_time_zone('London') + 2.days, mobilisation_period_required: true, mobilisation_period: 4)
              procurement.valid?(:entering_requirements)
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
              procurement.valid?(:entering_requirements)
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
              expect(procurement.valid?(:entering_requirements)).to be false
            end
          end
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end
end
