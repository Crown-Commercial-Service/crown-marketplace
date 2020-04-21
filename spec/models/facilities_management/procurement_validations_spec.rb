require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurement, type: :model do
  subject(:procurement) { build(:facilities_management_procurement, user: user) }

  let(:user) { build(:user) }

  describe '#tupevalidations' do
    context 'when editing TUPE' do
      context 'when it is blank' do
        it 'expected to be invalid' do
          procurement.tupe = ''
          expect(procurement.valid?(:tupe)).to eq false
        end

        it 'expected to be invalid when nil' do
          procurement.tupe = nil
          expect(procurement.valid?(:tupe)).to eq false
        end
      end
    end

    context 'when set to a string value' do
      context 'when it is not a boolean value' do
        it 'is invalid' do
          procurement.tupe = 'nottupe'
          expect(procurement.tupe).to eq true
          expect(procurement.valid?(:tupe)).to eq true
        end
      end

      context 'when it is a string representation of TRUE' do
        it 'is invalid' do
          procurement.tupe = 'true'
          expect(procurement.tupe).to eq true
          expect(procurement.valid?(:tupe)).to eq true
        end
      end

      context 'when it is a string representation of FALSE' do
        it 'is invalid' do
          procurement.tupe = 'false'
          expect(procurement.tupe).to eq false
          expect(procurement.valid?(:tupe)).to eq true
        end
      end
    end

    context 'when set to a boolean value' do
      context 'when it is true' do
        it 'is valid' do
          procurement.tupe = true
          expect(procurement.tupe).to eq true
          expect(procurement.valid?(:tupe)).to eq true
        end
      end

      context 'when it is false' do
        it 'is valid' do
          procurement.tupe = false
          expect(procurement.tupe).to eq false
          expect(procurement.valid?(:tupe)).to eq true
        end
      end

      context 'when it is yes' do
        it 'is valid' do
          procurement.tupe = 'yes'
          expect(procurement.tupe).to eq true
          expect(procurement.valid?(:tupe)).to eq true
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
        expect(procurement.valid?(:choose_contract_value)).to eq false
      end
    end

    context 'when the assesed value is below 7 million' do
      before do
        procurement.assessed_value = 6999999
      end

      context 'when lot_number is 1a' do
        it 'is valid' do
          procurement.lot_number = '1a'
          expect(procurement.valid?(:choose_contract_value)).to eq true
        end

        context 'when the lot_number_selected_by_customer' do
          it 'is not valid' do
            procurement.lot_number_selected_by_customer = false
            expect(procurement.valid?(:choose_contract_value)).to eq false
          end
        end
      end

      context 'when lot_number is 1b' do
        it 'is valid' do
          procurement.lot_number = '1b'
          expect(procurement.valid?(:choose_contract_value)).to eq true
        end
      end

      context 'when lot_number is 1c' do
        it 'is valid' do
          procurement.lot_number = '1c'
          expect(procurement.valid?(:choose_contract_value)).to eq true
        end
      end

      context 'when lot_number is not 1a, 1b or 1c' do
        it 'is not valid' do
          procurement.lot_number = '1d'
          expect(procurement.valid?(:choose_contract_value)).to eq false
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
          expect(procurement.valid?(:choose_contract_value)).to eq false
        end
      end

      context 'when lot_number is 1b' do
        it 'is valid' do
          procurement.lot_number = '1b'
          expect(procurement.valid?(:choose_contract_value)).to eq true
        end

        context 'when the lot_number_selected_by_customer' do
          it 'is not valid' do
            procurement.lot_number_selected_by_customer = false
            expect(procurement.valid?(:choose_contract_value)).to eq false
          end
        end
      end

      context 'when lot_number is 1c' do
        it 'is valid' do
          procurement.lot_number = '1c'
          expect(procurement.valid?(:choose_contract_value)).to eq true
        end
      end

      context 'when lot_number is not 1a, 1b or 1c' do
        it 'is not valid' do
          procurement.lot_number = '1d'
          expect(procurement.valid?(:choose_contract_value)).to eq false
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
          expect(procurement.valid?(:choose_contract_value)).to eq false
        end
      end

      context 'when lot_number is 1b' do
        it 'is valid' do
          procurement.lot_number = '1b'
          expect(procurement.valid?(:choose_contract_value)).to eq false
        end
      end

      context 'when lot_number is 1c' do
        it 'is valid' do
          procurement.lot_number = '1c'
          expect(procurement.valid?(:choose_contract_value)).to eq true
        end

        context 'when the lot_number_selected_by_customer' do
          it 'is not valid' do
            procurement.lot_number_selected_by_customer = false
            expect(procurement.valid?(:choose_contract_value)).to eq false
          end
        end
      end

      context 'when lot_number is not 1a, 1b or 1c' do
        it 'is not valid' do
          procurement.lot_number = '1d'
          expect(procurement.valid?(:choose_contract_value)).to eq false
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
