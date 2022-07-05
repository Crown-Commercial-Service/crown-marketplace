require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::SupplierData, type: :model do
  describe 'latest_data' do
    let(:latest_data) { described_class.create }

    before do
      4.times { described_class.create(created_at: Time.zone.now - 1.day) }
      latest_data
    end

    it 'is the latest set of data' do
      expect(described_class.latest_data).to eq latest_data
    end
  end
end
