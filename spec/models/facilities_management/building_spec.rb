require 'rails_helper'

RSpec.describe FacilitiesManagement::Building, type: :model do
  describe '#building' do
    it { is_expected.to belong_to(:user) }
  end

  describe '#building_standard' do
    subject(:building) { create(:facilities_management_building) }

    context 'when testing for standard building' do
      it 'will return STANDARD for general building' do
        expect(building.building_standard).to eq('STANDARD')
      end
    end

    context 'when testing for non-standard building' do
      before do
        building.building_type = 'Data Centre Operations'
      end

      it 'will return NON-STANDARD for Data Centre Operations' do
        expect(building.building_standard).to eq('NON-STANDARD')
      end
    end
  end

  describe 'default values' do
    subject(:building) { create(:facilities_management_building_defaults) }

    context 'when saving an empty record', skip: true do
      before do
        building.save(validate: false)
        building.reload
      end

      it 'json should not be empty' do
        expect(building.building_json).not_to eq('{}')
      end

      it 'json should contain id == to building id' do
        expect(building.building_json[:id]).to eq(building.id)
      end

      it 'default status should be Incomplete' do
        expect(building.status).to eq('Incomplete')
      end
    end
  end

  describe 'with ActiveRecord data in the object' do
    subject(:building) { create(:facilities_management_building) }

    before do
      building.save
      building.reload
    end

    context 'when saving data supplied at the record' do
      it 'will load the building' do
        new_building = FacilitiesManagement::Building.find_by(id: building.id)
        expect(new_building.id).to eq(building.id)
        expect(new_building.building_name).to eq(building.building_name)
      end

      it 'will load the building and populate JSON property' do
        new_building = FacilitiesManagement::Building.find_by(id: building.id)
        expect(new_building.id).to eq(building.id)
        expect(new_building.building_json[:name]).to eq(building.building_name)
        expect(new_building[:building_json]['name']).to eq(building.building_name)
      end
    end

    context 'when saving a new record with name, address, the JSON should match' do
      context 'with complete address, will save show in JSON' do
        it 'will save line 1 correctly' do
          expect(building.building_json[:address]['fm-address-line-1'.to_sym]).to eq(building.address_line_1)
        end

        it 'will save line 2 correctly' do
          expect(building.building_json[:address]['fm-address-line-2'.to_sym]).to eq(building.address_line_2)
        end

        it 'will save region correctly' do
          expect(building.building_json[:address]['fm-address-region'.to_sym]).to eq(building.address_region)
        end

        it 'will save postcode correctly' do
          expect(building.building_json[:address]['fm-address-postcode'.to_sym]).to eq(building.address_postcode)
        end

        it 'will save region-code correctly' do
          expect(building.building_json[:address]['fm-address-region-code'.to_sym]).to eq(building.address_region_code)
        end
      end
    end

    context 'when updating fields, they are reflected in the json' do
      it 'change the gia, it will be in the json' do
        building.gia = 2012
        building.save
        building.reload
        expect(building.building_json[:gia]).to eq(2012)
      end
    end
  end

  describe '#validations' do
    subject(:building) { create(:facilities_management_building) }

    context 'when everything is present' do
      it 'is valid' do
        expect(building.valid?(:all)).to eq true
      end

      it '#status will be "Ready"' do
        expect(building.status).to eq 'Ready'
      end
    end

    context 'when required element not present' do
      before do
        building.building_name = nil
      end

      it 'is invalid' do
        expect(building.valid?(:all)).to eq false
      end

      it '#status will be "Incomplete"' do
        building.valid?(:all)
        expect(building.status).to eq 'Incomplete'
      end
    end
  end
end
