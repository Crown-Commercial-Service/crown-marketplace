require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurement, type: :model do
  subject(:procurement) { build(:facilities_management_procurement, user: user) }

  let(:user) { build(:user) }

  describe '#validations' do
    context 'when no services selected' do
      before do
        procurement.service_codes = []
        procurement.valid?(:services)
      end

      it 'is invalid' do
        procurement.service_codes = []
        procurement.valid?(:services)
        expect(procurement.valid?(:services)).to eq false
      end

      it 'will have an error entry' do
        procurement.service_codes = []
        procurement.valid?(:services)
        expect(procurement.errors[:service_codes]).not_to be_empty
      end

      it 'will have its specific error message' do
        procurement.service_codes = []
        procurement.valid?(:services)
        expect(procurement.errors[:service_codes][0]).to eq 'Select at least one service you need to include in your procurement'
      end
    end
  end
end
