require 'rails_helper'

RSpec.describe FacilitiesManagement::ExpiredBuildings, type: :model do
  describe 'default values' do
    subject(:building) { create(:facilities_management_expired_buildings, user_id: create(:user).id) }

    context 'when saving an empty record' do
      before do
        building.save(validate: false)
        building.reload
      end

      it 'json should not be empty' do
        expect(building.building_json).not_to eq('{}')
      end

      it 'json should contain id=to building id' do
        expect(building.building_json['id']).to eq(building.id)
      end

      it 'default status should be Ready' do
        expect(building.status).to eq('Ready')
      end
    end
  end

  describe 'with ActiveRecord data in the object' do
    subject(:building) { create(:facilities_management_expired_buildings, user_id: create(:user).id) }

    before do
      building.save
      building.reload
    end

    context 'when saving a new record with name, address, the JSON should match' do
      it 'will save successfully' do
        expect(building.building_json['address']['fm-address-county']).to eq(building.address_county)
      end
    end
  end

  describe '#validations' do
    subject(:building) { create(:facilities_management_expired_buildings, user_id: create(:user).id) }

    context 'when everything is present' do
      it 'is valid' do
        expect(building.valid?(:all)).to eq true
      end
    end
  end
end
