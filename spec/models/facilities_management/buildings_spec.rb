require 'rails_helper'

RSpec.describe FacilitiesManagement::Buildings, type: :model do
  describe 'default values' do
    subject(:building) { create(:facilities_management_buildings_ar_defaults, user_id: create(:user).id) }

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

      it 'default status should be Incomplete' do
        expect(building.status).to eq('Incomplete')
      end
    end
  end

  describe 'with ActiveRecord data in the object' do
    subject(:building) { create(:facilities_management_buildings_ar, user_id: create(:user).id) }

    before do
      building.save
      building.reload
    end

    context 'when saving a new record with name, address, the JSON should match' do
      it 'will save successfully' do
        expect(building.building_json['address']['fm-address-county']).to eq(building.address_county)
      end
    end

    context 'when updating fields, they are reflected in the json' do
      it 'change the gia, it will be in the json' do
        building.gia = 2012
        building.save
        building.reload
        expect(building.building_json['gia']).to eq(2012)
      end
    end
  end

  describe 'with JSON data in the object' do
    subject(:building) { create(:facilities_management_buildings, user_id: create(:user).id) }

    before do
      building.save
      building.reload
    end

    context 'when saving a new record with name, address, the JSON should match' do
      it 'will save successfully' do
        expect(building.gia).to eq(1002)
        expect(building.address_county).to eq(building.building_json['address']['fm-address-county'])
      end
    end

    context 'when updating fields, they are reflected in the json' do
      it 'change the gia, it will be in the json' do
        building.building_json['gia'] = 2012
        expect(building.gia).to eq(1002)
        building.save
        building.reload
        expect(building.gia).to eq(2012)
      end
    end
  end

  describe '#validations' do
    subject(:building) { create(:facilities_management_buildings_ar, user_id: create(:user).id) }

    context 'when everything is present' do
      it 'is valid' do
        expect(building.valid?(:all)).to eq true
      end
    end

    context 'when required element not present' do
      before do
        building.building_name = nil
      end

      it 'is invalid' do
        expect(building.valid?(:all)).to eq false
      end
    end
  end
end
