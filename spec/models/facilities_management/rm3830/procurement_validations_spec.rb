require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Procurement do
  subject(:procurement) { build(:facilities_management_rm3830_procurement, user:) }

  let(:user) { build(:user) }

  describe 'services validation' do
    before { procurement.region_codes = ['UKC1'] }

    context 'when no service codes are selected' do
      it 'is not valid' do
        procurement.service_codes = nil
        expect(procurement.valid?(:service_codes)).to be false
      end
    end

    context 'when no service codes are empty' do
      it 'is not valid' do
        procurement.service_codes = []
        expect(procurement.valid?(:service_codes)).to be false
      end
    end

    context 'when some service codes are selected' do
      it 'is valid' do
        procurement.service_codes = ['C.1', 'C.2']
        expect(procurement.valid?(:service_codes)).to be true
      end
    end
  end

  describe 'region validation' do
    before { procurement.service_codes = ['C.1', 'C.2'] }

    context 'when no region codes are selected' do
      it 'is not valid' do
        procurement.region_codes = nil
        expect(procurement.valid?(:region_codes)).to be false
      end
    end

    context 'when no region codes are empty' do
      it 'is not valid' do
        procurement.region_codes = []
        expect(procurement.valid?(:region_codes)).to be false
      end
    end

    context 'when some region codes are selected' do
      it 'is valid' do
        procurement.region_codes = ['UKC1', 'UKN01']
        expect(procurement.valid?(:region_codes)).to be true
      end
    end
  end

  describe '#tupevalidations' do
    context 'when editing TUPE' do
      context 'when it is blank' do
        it 'expected to be invalid' do
          procurement.tupe = ''
          expect(procurement.valid?(:tupe)).to be false
        end

        it 'expected to be invalid when nil' do
          procurement.tupe = nil
          expect(procurement.valid?(:tupe)).to be false
        end
      end
    end

    context 'when set to a string value' do
      context 'when it is not a boolean value' do
        it 'is invalid' do
          procurement.tupe = 'nottupe'
          expect(procurement.tupe).to be true
          expect(procurement.valid?(:tupe)).to be true
        end
      end

      context 'when it is a string representation of TRUE' do
        it 'is invalid' do
          procurement.tupe = 'true'
          expect(procurement.tupe).to be true
          expect(procurement.valid?(:tupe)).to be true
        end
      end

      context 'when it is a string representation of FALSE' do
        it 'is invalid' do
          procurement.tupe = 'false'
          expect(procurement.tupe).to be false
          expect(procurement.valid?(:tupe)).to be true
        end
      end
    end

    context 'when set to a boolean value' do
      context 'when it is true' do
        it 'is valid' do
          procurement.tupe = true
          expect(procurement.tupe).to be true
          expect(procurement.valid?(:tupe)).to be true
        end
      end

      context 'when it is false' do
        it 'is valid' do
          procurement.tupe = false
          expect(procurement.tupe).to be false
          expect(procurement.valid?(:tupe)).to be true
        end
      end

      context 'when it is yes' do
        it 'is valid' do
          procurement.tupe = 'yes'
          expect(procurement.tupe).to be true
          expect(procurement.valid?(:tupe)).to be true
        end
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe 'choose_contract_value validation' do
    before do
      procurement.aasm_state = 'choose_contract_value'
      procurement.lot_number_selected_by_customer = true
    end

    context 'when lot_number is nil' do
      it 'is not valid' do
        procurement.lot_number = nil
        procurement.assessed_value = 5000000
        expect(procurement.valid?(:choose_contract_value)).to be false
      end
    end

    context 'when the assesed value is below 7 million' do
      before do
        procurement.assessed_value = 6999999
      end

      context 'when lot_number is 1a' do
        it 'is valid' do
          procurement.lot_number = '1a'
          expect(procurement.valid?(:choose_contract_value)).to be true
        end

        context 'when the lot_number_selected_by_customer' do
          it 'is not valid' do
            procurement.lot_number_selected_by_customer = false
            expect(procurement.valid?(:choose_contract_value)).to be false
          end
        end
      end

      context 'when lot_number is 1b' do
        it 'is valid' do
          procurement.lot_number = '1b'
          expect(procurement.valid?(:choose_contract_value)).to be true
        end
      end

      context 'when lot_number is 1c' do
        it 'is valid' do
          procurement.lot_number = '1c'
          expect(procurement.valid?(:choose_contract_value)).to be true
        end
      end

      context 'when lot_number is not 1a, 1b or 1c' do
        it 'is not valid' do
          procurement.lot_number = '1d'
          expect(procurement.valid?(:choose_contract_value)).to be false
        end
      end
    end

    context 'when the assesed value is between 7 million and 50 million' do
      before do
        procurement.assessed_value = 7000000
      end

      context 'when lot_number is 1a' do
        it 'is not valid' do
          procurement.lot_number = '1a'
          expect(procurement.valid?(:choose_contract_value)).to be false
        end
      end

      context 'when lot_number is 1b' do
        it 'is valid' do
          procurement.lot_number = '1b'
          expect(procurement.valid?(:choose_contract_value)).to be true
        end

        context 'when the lot_number_selected_by_customer' do
          it 'is not valid' do
            procurement.lot_number_selected_by_customer = false
            expect(procurement.valid?(:choose_contract_value)).to be false
          end
        end
      end

      context 'when lot_number is 1c' do
        it 'is valid' do
          procurement.lot_number = '1c'
          expect(procurement.valid?(:choose_contract_value)).to be true
        end
      end

      context 'when lot_number is not 1a, 1b or 1c' do
        it 'is not valid' do
          procurement.lot_number = '1d'
          expect(procurement.valid?(:choose_contract_value)).to be false
        end
      end
    end

    context 'when the assesed value above 50 million' do
      before do
        procurement.assessed_value = 50000001
      end

      context 'when lot_number is 1a' do
        it 'is not valid' do
          procurement.lot_number = '1a'
          expect(procurement.valid?(:choose_contract_value)).to be false
        end
      end

      context 'when lot_number is 1b' do
        it 'is valid' do
          procurement.lot_number = '1b'
          expect(procurement.valid?(:choose_contract_value)).to be false
        end
      end

      context 'when lot_number is 1c' do
        it 'is valid' do
          procurement.lot_number = '1c'
          expect(procurement.valid?(:choose_contract_value)).to be true
        end

        context 'when the lot_number_selected_by_customer' do
          it 'is not valid' do
            procurement.lot_number_selected_by_customer = false
            expect(procurement.valid?(:choose_contract_value)).to be false
          end
        end
      end

      context 'when lot_number is not 1a, 1b or 1c' do
        it 'is not valid' do
          procurement.lot_number = '1d'
          expect(procurement.valid?(:choose_contract_value)).to be false
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe 'governing_law validations' do
    context 'when no governing law value selected' do
      it 'is not valid' do
        procurement.governing_law = nil
        expect(procurement.valid?(:governing_law)).to be false
      end
    end

    context 'when invalid governing law entered' do
      it 'is not valid' do
        procurement.governing_law = 'bobbins'
        expect(procurement.valid?(:governing_law)).to be false
      end
    end

    context 'when valid governing law entered' do
      it 'is valid' do
        procurement.governing_law = 'english'
        expect(procurement.valid?(:governing_law)).to be true
      end
    end
  end

  describe '.contract_period_in_past?' do
    before do
      procurement.update(initial_call_off_start_date:)
    end

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
    before do
      procurement.update(initial_call_off_start_date: Time.now.in_time_zone('London') + 5.weeks)
      procurement.update(mobilisation_period_required: true)
      procurement.update(mobilisation_period:)
    end

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

  describe '.mobilisation_period_valid_when_tupe_required?' do
    let(:mobilisation_period_required) { false }
    let(:mobilisation_period) { 4 }

    before do
      procurement.update(tupe:)
      procurement.update(mobilisation_period_required:)
      procurement.update(mobilisation_period:)
    end

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
  end

  describe 'validation for special service choices' do
    before { procurement.service_codes = service_codes }

    context 'when the only service code selected is O.1' do
      let(:service_codes) { ['O.1'] }

      it 'will not be valid' do
        expect(procurement.valid?(:services)).to be false
      end

      it 'will have the correct error message' do
        procurement.valid?(:services)
        expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
      end

      context 'when another service is included as well' do
        before { procurement.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement.valid?(:services)).to be true
        end
      end
    end

    context 'when the only service code selected is N.1' do
      let(:service_codes) { ['N.1'] }

      it 'will not be valid' do
        expect(procurement.valid?(:services)).to be false
      end

      it 'will have the correct error message' do
        procurement.valid?(:services)
        expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
      end

      context 'when another service is included as well' do
        before { procurement.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement.valid?(:services)).to be true
        end
      end
    end

    context 'when the only service code selected is M.1' do
      let(:service_codes) { ['M.1'] }

      it 'will not be valid' do
        expect(procurement.valid?(:services)).to be false
      end

      it 'will have the correct error message' do
        procurement.valid?(:services)
        expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
      end

      context 'when another service is included as well' do
        before { procurement.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement.valid?(:services)).to be true
        end
      end
    end

    context 'when the only service codes selected are only O.1 and M.1' do
      let(:service_codes) { ['O.1', 'M.1'] }

      it 'will not be valid' do
        expect(procurement.valid?(:services)).to be false
      end

      it 'will have the correct error message' do
        procurement.valid?(:services)
        expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
      end

      context 'when another service is included as well' do
        before { procurement.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement.valid?(:services)).to be true
        end
      end
    end

    context 'when the only service codes selected are only O.1 and N.1' do
      let(:service_codes) { ['O.1', 'N.1'] }

      it 'will not be valid' do
        expect(procurement.valid?(:services)).to be false
      end

      it 'will have the correct error message' do
        procurement.valid?(:services)
        expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
      end

      context 'when another service is included as well' do
        before { procurement.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement.valid?(:services)).to be true
        end
      end
    end

    context 'when the only service codes selected are only M.1 and N.1' do
      let(:service_codes) { ['M.1', 'N.1'] }

      it 'will not be valid' do
        expect(procurement.valid?(:services)).to be false
      end

      it 'will have the correct error message' do
        procurement.valid?(:services)
        expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
      end

      context 'when another service is included as well' do
        before { procurement.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement.valid?(:services)).to be true
        end
      end
    end

    context 'when the only service codes selected are only O.1, N.1 and M.1' do
      let(:service_codes) { ['O.1', 'N.1', 'M.1'] }

      it 'will not be valid' do
        expect(procurement.valid?(:services)).to be false
      end

      it 'will have the correct error message' do
        procurement.valid?(:services)
        expect(procurement.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
      end

      context 'when another service is included as well' do
        before { procurement.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement.valid?(:services)).to be true
        end
      end
    end

    context 'when the only service codes selected include G.1 and G.3' do
      let(:service_codes) { ['G.1', 'G.3'] }

      it 'will be valid' do
        expect(procurement.valid?(:services)).to be true
      end
    end
  end
end
