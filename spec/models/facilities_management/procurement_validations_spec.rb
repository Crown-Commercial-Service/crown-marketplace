require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurement, type: :model do
  subject(:procurement) { build(:facilities_management_procurement, user: user) }

  let(:user) { build(:user) }

  describe '#tupevalidations' do
    context 'when editing TUPE' do
      context 'when it is blank' do
        it 'expected to be invalid' do
          procurement.tupe = ''
          procurement.valid?(:tupe)
          puts $stdout, procurement.errors.details.to_json
          expect(procurement.valid?(:tupe)).to eq false
        end

        it 'expected to be invalid when nil' do
          procurement.tupe = nil
          procurement.valid?(:tupe)
          puts $stdout, procurement.errors.details.to_json
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
end
