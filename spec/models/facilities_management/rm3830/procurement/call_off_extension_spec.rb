require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Procurement::CallOffExtension do
  subject(:call_off_extension) { create(:facilities_management_rm3830_procurement_call_off_extension) }

  describe 'validatins' do
    let(:years) { 4 }
    let(:months) { 2 }

    before do
      call_off_extension.years = years
      call_off_extension.months = months
    end

    context 'when considering just the years' do
      context 'and they are nil' do
        let(:years) { nil }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          call_off_extension.valid?(:contract_period)
          expect(call_off_extension.errors[:years].first).to eq 'Enter the years for the extension period'
        end
      end

      context 'and they are blank' do
        let(:years) { '' }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          call_off_extension.valid?(:contract_period)
          expect(call_off_extension.errors[:years].first).to eq 'Enter the years for the extension period'
        end
      end

      context 'and they are empty' do
        let(:years) { '    ' }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          call_off_extension.valid?(:contract_period)
          expect(call_off_extension.errors[:years].first).to eq 'Enter the years for the extension period'
        end
      end

      context 'and it is less than 0' do
        let(:years) { -1 }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          call_off_extension.valid?(:contract_period)
          expect(call_off_extension.errors[:years].first).to eq 'The years for the extension period must be greater than or equal to 0'
        end
      end

      context 'and it is not a number' do
        let(:years) { 'TEN' }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          call_off_extension.valid?(:contract_period)
          expect(call_off_extension.errors[:years].first).to eq 'The years for the extension period must be a whole number'
        end
      end

      context 'and it is a number greater than or equal to 0' do
        it 'is valid' do
          expect(call_off_extension.valid?(:contract_period)).to be true
        end
      end
    end

    context 'when considering just the months' do
      context 'and they are nil' do
        let(:months) { nil }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          call_off_extension.valid?(:contract_period)
          expect(call_off_extension.errors[:months].first).to eq 'Enter the months for the extension period'
        end
      end

      context 'and they are blank' do
        let(:months) { '' }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          call_off_extension.valid?(:contract_period)
          expect(call_off_extension.errors[:months].first).to eq 'Enter the months for the extension period'
        end
      end

      context 'and they are empty' do
        let(:months) { '    ' }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          call_off_extension.valid?(:contract_period)
          expect(call_off_extension.errors[:months].first).to eq 'Enter the months for the extension period'
        end
      end

      context 'and it is less than 0' do
        let(:months) { -1 }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          call_off_extension.valid?(:contract_period)
          expect(call_off_extension.errors[:months].first).to eq 'The months for the extension period must be between 0 and 11'
        end
      end

      context 'and it is greater than 11' do
        let(:months) { 12 }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          call_off_extension.valid?(:contract_period)
          expect(call_off_extension.errors[:months].first).to eq 'The months for the extension period must be between 0 and 11'
        end
      end

      context 'and it is not a number' do
        let(:months) { 'NINE' }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          call_off_extension.valid?(:contract_period)
          expect(call_off_extension.errors[:months].first).to eq 'The months for the extension period must be a whole number'
        end
      end

      context 'and it is a number between 0 and 11' do
        it 'is valid' do
          expect(call_off_extension.valid?(:contract_period)).to be true
        end
      end
    end

    context 'when considering the years and months together' do
      context 'and they are both 0' do
        let(:years) { 0 }
        let(:months) { 0 }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          call_off_extension.valid?(:contract_period)
          expect(call_off_extension.errors[:base].first).to eq 'The total for extension period 1 must be greater than 1 month'
        end
      end

      context 'and the total length is 1 month' do
        let(:years) { 0 }
        let(:months) { 1 }

        it 'is valid' do
          expect(call_off_extension.valid?(:contract_period)).to be true
        end

        it 'has a contract length of 1 month' do
          expect(call_off_extension.period).to eq 1.month
        end
      end

      context 'and the total length is more than 1 month' do
        it 'is valid' do
          expect(call_off_extension.valid?(:contract_period)).to be true
        end

        it 'has a contract length of 1 month' do
          expect(call_off_extension.period).to eq(4.years + 2.months)
        end
      end
    end

    context 'when considering the extension' do
      context 'and it is a number less than 0' do
        let(:extension) { -1 }

        before { call_off_extension.extension = extension }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end
      end

      context 'and it is a number greater than 3' do
        let(:extension) { 4 }

        before { call_off_extension.extension = extension }

        it 'is not valid' do
          expect(call_off_extension.valid?(:contract_period)).to be false
        end
      end

      context 'and it is a already in use by another period' do
        let(:procurement) { call_off_extension.procurement }
        let(:new_extension) { procurement.call_off_extensions.build(extension: 0, extension_required: 'true') }

        before { new_extension }

        it 'is will not save' do
          expect(procurement.valid?(:contract_period)).to be false
        end
      end
    end
  end

  describe 'scope sorted' do
    let(:procurement) { call_off_extension.procurement }

    before do
      (1..3).each do |extension|
        procurement.call_off_extensions.create(extension: 4 - extension, years: 1, months: 1)
      end
    end

    it 'is not sorted without the scope' do
      expect(procurement.call_off_extensions.pluck(:extension)).to eq [0, 3, 2, 1]
    end

    it 'is sorted with the scope' do
      expect(procurement.call_off_extensions.sorted.pluck(:extension)).to eq [0, 1, 2, 3]
    end
  end
end
