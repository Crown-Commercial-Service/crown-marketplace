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

    context 'when saving an empty record' do
      before do
        building.save(validate: false)
        building.reload
      end

      it 'json should be empty' do
        expect(building.building_json).to eq nil
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

  describe '#building_standard' do
    subject(:building) { create(:facilities_management_building) }

    context 'when the building is a standard type' do
      it 'returns STANDARD when General office - Customer Facing' do
        expect(building.building_standard).to eq 'STANDARD'
      end

      it 'returns STANDARD when Call Centre Operations' do
        building.building_type = 'Call Centre Operations'
        expect(building.building_standard).to eq 'STANDARD'
      end

      it 'returns STANDARD when Primary school' do
        building.building_type = 'Primary School'
        expect(building.building_standard).to eq 'STANDARD'
      end

      it 'returns STANDARD when Restaurant and Catering-Facilities' do
        building.building_type = 'Restaurant and Catering Facilities'
        expect(building.building_standard).to eq 'STANDARD'
      end

      it 'returns STANDARD when Special Schools' do
        building.building_type = 'Special Schools'
        expect(building.building_standard).to eq 'STANDARD'
      end

      it 'returns STANDARD when Universities and Colleges' do
        building.building_type = 'Universities and Colleges'
        expect(building.building_standard).to eq 'STANDARD'
      end

      it 'returns STANDARD when Doctors, Dentists and Health Clinics' do
        building.building_type = 'Community - Doctors, Dentist, Health Clinic'
        expect(building.building_standard).to eq 'STANDARD'
      end

      it 'returns STANDARD when Nursery and Care-Homes' do
        building.building_type = 'Nursing and Care Homes'
        expect(building.building_standard).to eq 'STANDARD'
      end
    end

    context 'when the building is not a standard type' do
      it 'returns NON-STANDARD when Nuclear Facilities' do
        building.building_type = 'Nuclear Facilities'
        expect(building.building_standard).to eq 'NON-STANDARD'
      end

      it 'returns NON-STANDARD when Fitness or Training Establishments' do
        building.building_type = 'Fitness or Training Establishments'
        expect(building.building_standard).to eq 'NON-STANDARD'
      end

      it 'returns NON-STANDARD when List X Property' do
        building.building_type = 'List X Property'
        expect(building.building_standard).to eq 'NON-STANDARD'
      end
    end
  end
end
