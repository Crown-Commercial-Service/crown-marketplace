require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementPensionFund, type: :model do
  subject(:pension_fund) { build(:facilities_management_procurement_pension_fund, procurement: create(:facilities_management_procurement)) }

  describe '#valid_pension?' do
    context 'when the name and percentage are valid' do
      it 'is expected to be valid' do
        expect(pension_fund.valid?).to eq true
      end
    end

    describe '#valid_name?' do
      # Validating the name
      context 'when the name is more than 150 characters' do
        it 'is expected to not be valid' do
          pension_fund.name = (0...151).map { ('a'..'z').to_a[rand(26)] }.join
          expect(pension_fund.valid?).to eq false
          pension_fund.name = (0...rand(151..300)).map { ('a'..'z').to_a[rand(26)] }.join
          expect(pension_fund.valid?).to eq false
        end
      end

      context 'when the name is blank' do
        it 'is expected to not be valid' do
          pension_fund.name = ''
          expect(pension_fund.valid?).to eq false
          pension_fund.name = '     '
          expect(pension_fund.valid?).to eq false
        end
      end

      context 'when the name is not unique' do
        let(:pension_fund_1) { create(:facilities_management_procurement_pension_fund, procurement: create(:facilities_management_procurement)) }
        let(:pension_fund_2) { create(:facilities_management_procurement_pension_fund, procurement: pension_fund_1.procurement) }

        it 'expected to be valid' do
          pension_fund_2.name = pension_fund_1.name + 'ABC'
          expect(pension_fund_1.valid?(:name)).to eq true
        end

        it 'expected to not be valid' do
          pension_fund_2.name = pension_fund_1.name
          expect(pension_fund_2.valid?(:name)).to eq false
        end
      end

      context 'when the name is between 1 and 150 characters inclusive' do
        it 'is expected to be valid' do
          pension_fund.name = 'a'
          expect(pension_fund.valid?).to eq true
          pension_fund.name = (0...150).map { ('a'..'z').to_a[rand(26)] }.join
          expect(pension_fund.valid?).to eq true
          pension_fund.name = (0...rand(1..149)).map { ('a'..'z').to_a[rand(26)] }.join
          expect(pension_fund.valid?).to eq true
        end
      end
    end

    describe '#valid_percentage?' do
      # Validating the percentage
      context 'when the percentage is less than 1' do
        it 'is expected to not be valid' do
          pension_fund.percentage = 0
          expect(pension_fund.valid?).to eq false
          pension_fund.percentage = rand(-100..-1)
          expect(pension_fund.valid?).to eq false
        end
      end

      context 'when the percentage is more than 100' do
        it 'is expected to not be valid' do
          pension_fund.percentage = 101
          expect(pension_fund.valid?).to eq false
          pension_fund.percentage = rand(101..200)
          expect(pension_fund.valid?).to eq false
        end
      end

      context 'when the percentage is blank' do
        it 'is expected to not be valid' do
          pension_fund.percentage = nil
          expect(pension_fund.valid?).to eq false
        end
      end

      context 'when the percentage is not a number' do
        it 'is expected to not be valid' do
          pension_fund.percentage = (0...5).map { ('a'..'z').to_a[rand(26)] }.join
          expect(pension_fund.valid?).to eq false
        end
      end

      context 'when the percentage is not a whole number' do
        it 'is expected to not be valid' do
          pension_fund.percentage = (100 * rand(2..100) / 101.0)
          expect(pension_fund.valid?).to eq false
        end
      end

      context 'when the percentage is between 1 and 100 percent inclusive' do
        it 'is expected to be false' do
          pension_fund.percentage = 1
          expect(pension_fund.valid?).to eq true
          pension_fund.percentage = rand(1..100)
          expect(pension_fund.valid?).to eq true
          pension_fund.percentage = 100
          expect(pension_fund.valid?).to eq true
        end
      end
    end
  end
end
