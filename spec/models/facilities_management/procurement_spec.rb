require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurement, type: :model do
  subject(:procurement) { build(:facilities_management_procurement, user: user) }

  let(:user) { build(:user) }

  it { is_expected.to be_valid }

  describe '#name' do
    context 'when the name is more than 100 characters' do
      it 'is expected to not be valid' do
        procurement.name = (0...101).map { ('a'..'z').to_a[rand(26)] }.join

        expect(procurement.valid?(:name)).to eq false
      end
    end

    context 'when the name is not unique' do
      let(:second_procurement) {  build(:facilities_management_procurement, name: procurement.name, user: user) }

      it 'expected to not be valid' do
        procurement.save

        expect(second_procurement.valid?(:name)).to eq false
      end
    end

    context 'when the name is not present' do
      it 'expected to not be valid' do
        procurement.name = nil
        expect(procurement.valid?(:name)).to eq false
      end
    end
  end

  describe '#contract_name' do
    context 'when the name is more than 100 characters' do
      it 'is expected to not be valid' do
        procurement.contract_name = (0...101).map { ('a'..'z').to_a[rand(26)] }.join

        expect(procurement.valid?(:contract_name)).to eq false
      end
    end

    context 'when the name is not present' do
      it 'expected to not be valid' do
        procurement.contract_name = 'Valid Name'
        expect(procurement.valid?(:contract_name)).to eq true
      end
    end
  end

  describe '#estimated_annual_cost' do
    context 'when the estimated_annual_cost is present' do
      it 'expected to be valid' do
        procurement.estimated_annual_cost = 25000
        expect(procurement.valid?(:annual_cost)).to eq true
      end
    end
    context 'when the estimated_annual_cost is not present' do
      it 'expected to not be valid' do
        expect(procurement.valid?(:annual_cost)).to eq false
      end
    end
  end
end
