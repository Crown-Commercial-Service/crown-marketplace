require 'rails_helper'

RSpec.describe FacilitiesManagement::Building, type: :model do
  describe 'default values' do
    subject(:building) { create(:facilities_management_building_ar_defaults, user_id: create(:user).id) }
    
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
  
  describe '#validations' do
    subject(:building) { create(:facilities_management_building_ar, user_id: create(:user).id) }
    
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
