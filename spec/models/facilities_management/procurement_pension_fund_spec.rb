require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementPensionFund, type: :model do
  subject(:pension_fund) { build(:facilities_management_procurement_pension_fund, procurement: create(:facilities_management_procurement)) }

  describe '#pension_fund' do
    # Validating the name
    context 'when the name is more than 150 characters' do
      it 'is expected to not be valid' do
        pension_fund.name = (0...151).map { ('a'..'z').to_a[rand(26)] }.join
        expect(pension_fund.valid?(:pension_fund)).to eq false
        pension_fund.name = (0...rand(151..300)).map { ('a'..'z').to_a[rand(26)] }.join
        expect(pension_fund.valid?(:pension_fund)).to eq false
      end
    end

    context 'when the name is blank' do
      it 'is expected to not be valid' do
        pension_fund.name = nil
        expect(pension_fund.valid?(:pension_fund)).to eq false
        pension_fund.name = ''
        expect(pension_fund.valid?(:pension_fund)).to eq false
      end
    end

    context 'when the name is between 1 and 150 characters inclusive' do
      it 'is expected to be valid' do
        pension_fund.name = 'a'
        expect(pension_fund.valid?(:pension_fund)).to eq true
        pension_fund.name = (0...150).map { ('a'..'z').to_a[rand(26)] }.join
        expect(pension_fund.valid?(:pension_fund)).to eq true
        pension_fund.name = (0...rand(1..149)).map { ('a'..'z').to_a[rand(26)] }.join
        expect(pension_fund.valid?(:pension_fund)).to eq true
      end
    end

    # Validating the percentage
    context 'when the percentage is less than 1' do
      it 'is expected to not be valid' do
        pension_fund.percentage = 0
        expect(pension_fund.valid?(:pension_fund)).to eq false
        pension_fund.percentage = -rand(1..100)
        expect(pension_fund.valid?(:pension_fund)).to eq false
      end
    end

    context 'when the percentage is more than 100' do
      it 'is expected to not be valid' do
        pension_fund.percentage = 101
        expect(pension_fund.valid?(:pension_fund)).to eq false
        pension_fund.percentage = rand(101..200)
        expect(pension_fund.valid?(:pension_fund)).to eq false
      end
    end

    context 'when the percentage is blank' do
      it 'is expected to not be valid' do
        pension_fund.percentage = nil
        expect(pension_fund.valid?(:pension_fund)).to eq false
      end
    end

    context 'when the percentage is not a number' do
      it 'is expected to not be valid' do
        pension_fund.percentage = (0...5).map { ('a'..'z').to_a[rand(26)] }.join
        expect(pension_fund.valid?(:pension_fund)).to eq false
      end
    end

    context 'when the percentage is between 1 and 100 percent inclusive' do
      it 'is expected to be valid' do
        pension_fund.percentage = 1
        expect(pension_fund.valid?(:pension_fund)).to eq true
        pension_fund.percentage = rand(1..100)
        expect(pension_fund.valid?(:pension_fund)).to eq true
        pension_fund.percentage = 100
        expect(pension_fund.valid?(:pension_fund)).to eq true
      end
    end
  end

  describe '#percentage' do
    context 'when the percentage is not a whole number' do
      let(:percentage_with_decimals) { rand(2..100). * (100.0 / 101.0) }
      let(:percentage_float) { rand(2..100).to_f }

      it 'is expected to return integer part of number' do
        pension_fund.percentage = percentage_with_decimals
        expect(pension_fund.percentage).to be percentage_with_decimals.to_i

        pension_fund.percentage = percentage_float
        expect(pension_fund.percentage).to be percentage_float.to_i
      end

      it 'is expected to return an integer' do
        pension_fund.percentage = percentage_with_decimals
        expect(pension_fund.percentage).to be_an_instance_of(Integer)

        pension_fund.percentage = percentage_float
        expect(pension_fund.percentage).to be_an_instance_of(Integer)
      end

      it 'is expected to be valid' do
        pension_fund.percentage = percentage_with_decimals
        expect(pension_fund.valid?(:pension_fund)).to eq true

        pension_fund.percentage = percentage_float
        expect(pension_fund.valid?(:pension_fund)).to eq true
      end
    end
  end
end
