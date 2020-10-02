require 'rails_helper'
# rubocop:disable RSpec/NestedGroups
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

    context 'when the building name is a duplicate' do
      let(:duplicate_building) { create(:facilities_management_building, user: building.user) }

      before do
        duplicate_building.update(building_name: building.building_name)
      end

      it 'is not valid' do
        expect(duplicate_building.valid?(:all)).to eq false
      end

      it 'is taken' do
        duplicate_building.valid?(:all)
        expect(duplicate_building.errors.details[:building_name].first[:error]).to eq :taken
      end
    end

    context 'when the building name is too long' do
      before do
        building.building_name = 'a' * 51
      end

      it 'is invalid' do
        expect(building.valid?(:all)).to eq false
      end

      it 'will have the correct error message' do
        building.valid?(:all)
        expect(building.errors[:building_name].first).to eq 'Building name must be 50 characters or less'
      end
    end

    context 'when the building name is within range' do
      before do
        building.description = 'a' * 50
      end

      it 'is valid' do
        expect(building.valid?(:all)).to eq true
      end
    end

    context 'when the building description is too long' do
      before do
        building.description = 'a' * 51
      end

      it 'is invalid' do
        expect(building.valid?(:all)).to eq false
      end

      it 'will have the correct error message' do
        building.valid?(:all)
        expect(building.errors[:description].first).to eq 'Building description must be 50 characters or less'
      end
    end

    context 'when the building description is within range' do
      before do
        building.description = 'a' * 50
      end

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

      it '#status will be "Incomplete"' do
        building.valid?(:all)
        expect(building.status).to eq 'Incomplete'
      end
    end

    context 'when saving GIA' do
      before do
        building.gia = gia
      end

      context 'when gia is not present' do
        let(:gia) { nil }

        before { building.valid? :gia }

        it 'is invalid' do
          expect(building.valid?(:all)).to eq false
          expect(building.valid?(:gia)).to eq false
        end

        it 'will have gia errors' do
          expect(building.errors.details[:gia].first.dig(:error)).to eq :blank
        end

        it 'will have the correct error message' do
          expect(building.errors[:gia].first).to eq 'Internal area must be a number between 0 and 999,999,999'
        end
      end

      context 'when gia is a float' do
        let(:gia) { 434.2 }

        before { building.valid? :gia }

        it 'is invalid' do
          expect(building.valid?(:all)).to eq false
          expect(building.valid?(:gia)).to eq false
        end

        it 'will have the correct error' do
          expect(building.errors.details.dig(:gia).first.dig(:error)).to eq :not_an_integer
        end

        it 'will have the correct error message' do
          expect(building.errors[:gia].first).to eq 'Enter a whole number for the size of internal area of this building'
        end
      end

      context 'when gia is not an integer' do
        let(:gia) { 'some words' }

        before { building.valid? :gia }

        it 'is invalid' do
          expect(building.valid?(:all)).to eq false
          expect(building.valid?(:gia)).to eq false
        end

        it 'will have the correct error' do
          expect(building.errors.details.dig(:gia).first.dig(:error)).to eq :not_a_number
        end

        it 'will have the correct error message' do
          expect(building.errors[:gia].first).to eq 'Gross Internal Area (GIA) must be a whole number'
        end
      end

      context 'when gia is too large' do
        let(:gia) { 1000000000 }

        before { building.valid? :gia }

        it 'is invalid' do
          expect(building.valid?(:all)).to eq false
          expect(building.valid?(:gia)).to eq false
        end

        it 'will have the correct error' do
          expect(building.errors.details.dig(:gia).first.dig(:error)).to eq :less_than_or_equal_to
        end

        it 'will have the correct error message' do
          expect(building.errors[:gia].first).to eq 'Internal area must be a number between 0 and 999,999,999'
        end
      end
    end

    context 'when saving external area' do
      before do
        building.external_area = external_area
      end

      context 'when external_area is not present' do
        let(:external_area) { nil }

        before { building.valid? :gia }

        it 'is invalid' do
          expect(building.valid?(:all)).to eq false
          expect(building.valid?(:gia)).to eq false
        end

        it 'will have gia errors' do
          expect(building.errors.details[:external_area].first.dig(:error)).to eq :blank
        end

        it 'will have the correct error message' do
          expect(building.errors[:external_area].first).to eq 'External area must be a number between 0 and 999,999,999'
        end
      end

      context 'when external_area is a float' do
        let(:external_area) { 434.2 }

        before { building.valid? :gia }

        it 'is invalid' do
          expect(building.valid?(:all)).to eq false
          expect(building.valid?(:gia)).to eq false
        end

        it 'will have the correct error' do
          expect(building.errors.details.dig(:external_area).first.dig(:error)).to eq :not_an_integer
        end

        it 'will have the correct error message' do
          expect(building.errors[:external_area].first).to eq 'Enter a whole number for the size of external area of this building'
        end
      end

      context 'when external_area is not an integer' do
        let(:external_area) { 'some words' }

        before { building.valid? :gia }

        it 'is invalid' do
          expect(building.valid?(:all)).to eq false
          expect(building.valid?(:gia)).to eq false
        end

        it 'will have the correct error' do
          expect(building.errors.details.dig(:external_area).first.dig(:error)).to eq :not_a_number
        end

        it 'will have the correct error message' do
          expect(building.errors[:external_area].first).to eq 'External area must be a whole number'
        end
      end

      context 'when external_area is too large' do
        let(:external_area) { 1000000000 }

        before { building.valid? :gia }

        it 'is invalid' do
          expect(building.valid?(:all)).to eq false
          expect(building.valid?(:gia)).to eq false
        end

        it 'will have the correct error' do
          expect(building.errors.details.dig(:external_area).first.dig(:error)).to eq :less_than_or_equal_to
        end

        it 'will have the correct error message' do
          expect(building.errors[:external_area].first).to eq 'External area must be a number between 0 and 999,999,999'
        end
      end
    end

    context 'when external_area and gia are both zero' do
      before do
        building.gia = 0
        building.external_area = 0
        building.valid? :gia
      end

      it 'will be invalid' do
        expect(building.errors.details.dig(:gia).first.dig(:error)).to eq :combined_area
        expect(building.errors.details.dig(:external_area).first.dig(:error)).to eq :combined_area
      end

      it 'will have the correct error messages' do
        expect(building.errors[:gia].first).to eq 'Internal area must be greater than 0, if the external area is 0.'
        expect(building.errors[:external_area].first).to eq 'External area must be greater than 0, if the internal area is 0.'
      end
    end

    context 'when saving security_type' do
      context 'when security_type is blank' do
        before do
          building.security_type = nil
        end

        it 'will be invalid' do
          building.valid? :security
          expect(building.errors.details.dig(:security_type).first.dig(:error)).to eq :blank
        end
      end

      context 'when security_type set to something' do
        it 'will not be valid' do
          building.security_type = 'something'
          expect(building.valid?(:security)).to eq false
        end
      end

      context 'when security_type set to Baseline personnel security standard (BPSS)' do
        it 'will be valid' do
          building.security_type = 'Baseline personnel security standard (BPSS)'
          expect(building.valid?(:security)).to eq true
        end
      end

      context 'when security_type set to Baseline personnel security standard (BPSS) and there is somthing in other' do
        before do
          building.security_type = 'Baseline personnel security standard (BPSS)'
          building.other_security_type = 'other security type'
        end

        it 'will be valid' do
          expect(building.valid?(:security)).to eq true
        end

        it 'will be not save other_security_type' do
          building.save(context: :security)
          expect(building.other_security_type).to eq nil
        end
      end

      context 'when other_security_type is blank' do
        before do
          building.security_type = :other
          building.valid? :security
        end

        it 'will be invalid' do
          expect(building.errors.details.dig(:other_security_type).first.dig(:error)).to eq :blank
        end
      end

      context 'when other_security_type contains carriage return characters' do
        it 'will be valid' do
          building.security_type       = :other
          building.other_security_type = ('a' * 140) + ("\r\n" * 10)
          expect(building.valid?(:security)).to eq true
        end
      end

      context 'when other_security_type is more than 150 characters' do
        it 'will be valid' do
          building.security_type       = :other
          building.other_security_type = ('a' * 141) + ("\r\n" * 10)
          expect(building.valid?(:security)).to eq false
        end
      end

      context 'when other_security_type is not blank' do
        before do
          building.security_type       = :other
          building.other_security_type = 'other security type'
        end

        it 'will be valid' do
          expect(building.valid?(:security)).to eq true
        end
      end
    end

    context 'when saving building_type' do
      context 'and building_type is blank' do
        before do
          building.building_type = nil
        end

        it 'will be invalid' do
          building.valid? :type
          expect(building.errors.details.dig(:building_type).first.dig(:error)).to eq :blank
        end
      end

      context 'when building_type set to something' do
        it 'will not be valid' do
          building.building_type = 'something'
          building.valid? :type
          expect(building.valid?(:type)).to eq false
        end
      end

      context 'when building_type is set to General office - Customer Facing' do
        it 'will be valid' do
          building.building_type = 'General office - Customer Facing'
          expect(building.valid?(:type)).to eq true
        end
      end

      context 'when other_building_type is blank' do
        before do
          building.building_type = :other
          building.valid? :type
        end

        it 'will be invalid' do
          expect(building.errors.details.dig(:other_building_type).first.dig(:error)).to eq :blank
        end
      end

      context 'when other_building_type set to General office - Customer Facing and there is somthing in other' do
        before do
          building.building_type = 'General office - Customer Facing'
          building.other_building_type = 'other building type'
        end

        it 'will be valid' do
          expect(building.valid?(:type)).to eq true
        end

        it 'will be not save other_building_type' do
          building.save(context: :type)
          expect(building.other_building_type).to eq nil
        end
      end

      context 'when other_building_type contains carriage return characters' do
        it 'will be valid' do
          building.building_type       = :other
          building.other_building_type = ('a' * 140) + ("\r\n" * 10)
          expect(building.valid?(:type)).to eq true
        end
      end

      context 'when other_building_type is more than 150 characters' do
        it 'will not be valid' do
          building.building_type       = :other
          building.other_building_type = ('a' * 141) + ("\r\n" * 10)
          expect(building.valid?(:type)).to eq false
        end
      end

      context 'when other_building_type is not blank' do
        it 'will be valid' do
          building.building_type       = :other
          building.other_building_type = 'other building type'
          expect(building.valid?(:type)).to eq true
        end
      end

      describe 'when saving address_line_1' do
        context 'when blank' do
          before do
            building.address_line_1 = nil
          end

          it 'will be invalid when manually adding an address' do
            building.valid? :add_address
            expect(building.errors.details.dig(:address_line_1).first.dig(:error)).to eq :blank
          end

          it 'will be valid if no postcode given' do
            building.address_postcode = nil
            building.valid? :all
            expect(building.errors.details.dig(:address_line_1)).to eq []
          end

          it 'will be invalid if a postcode is given' do
            building.valid? :all
            expect(building.errors.details.dig(:address_line_1).first.dig(:error)).to eq :blank
          end

          it 'will have the correct error message' do
            building.valid? :all
            expect(building.errors[:address_line_1].first).to eq 'Add a building and street name'
          end
        end

        context 'when it is more than the max number of characters' do
          before do
            building.address_line_1 = 'a' * 101
          end

          it 'will be invalid when manually adding an address' do
            building.valid? :add_address
            expect(building.errors.details.dig(:address_line_1).first.dig(:error)).to eq :too_long
          end

          it 'will be valid if no postcode given' do
            building.address_postcode = nil
            building.valid? :all
            expect(building.errors.details.dig(:address_line_1)).to eq []
          end

          it 'will be invalid if a postcode is given' do
            building.valid? :all
            expect(building.errors.details.dig(:address_line_1).first.dig(:error)).to eq :too_long
          end

          it 'will have the correct error message' do
            building.valid? :all
            expect(building.errors[:address_line_1].first).to eq 'Building and street name must be 100 characters or less'
          end
        end
      end

      describe 'when saving address_line_2' do
        context 'when it is more than the max number of characters' do
          before do
            building.address_line_2 = 'a' * 101
          end

          it 'will be invalid when manually adding an address' do
            building.valid? :add_address
            expect(building.errors.details.dig(:address_line_2).first.dig(:error)).to eq :too_long
          end

          it 'will be valid if no postcode given' do
            building.address_postcode = nil
            building.valid? :all
            expect(building.errors.details.dig(:address_line_2)).to eq []
          end

          it 'will be invalid if a postcode is given' do
            building.valid? :all
            expect(building.errors.details.dig(:address_line_2).first.dig(:error)).to eq :too_long
          end

          it 'will have the correct error message' do
            building.valid? :all
            expect(building.errors[:address_line_2].first).to eq 'Building and street name must be 100 characters or less'
          end
        end
      end

      context 'when saving address_town' do
        context 'when blank' do
          before do
            building.address_town = nil
            building.valid? :all
          end

          it 'will be invalid' do
            expect(building.errors.details.dig(:address_town).first.dig(:error)).to eq :blank
          end
        end
      end

      context 'when saving address region selection' do
        before do
          building.address_region = address_region
          building.address_region_code = address_region_code
          building.valid?(:all)
        end

        let(:address_region) { 'Shropshire and Staffordshire' }
        let(:address_region_code) { 'UKG2' }

        context 'when address_region is blank' do
          let(:address_region) { nil }

          it 'will be invalid if postcode and line 1 present' do
            expect(building.errors[:address_region].present?).to eq true
          end

          it 'will have the correct error message' do
            expect(building.errors[:address_region].first).to eq 'You must select a region for your address'
          end
        end

        context 'when address_region_code is blank' do
          let(:address_region_code) { nil }

          it 'will be invalid if postcode and line 1 present' do
            expect(building.errors[:address_region].present?).to eq true
          end

          it 'will have the correct error message' do
            expect(building.errors[:address_region].first).to eq 'You must select a region for your address'
          end
        end

        context 'when both are blank' do
          let(:address_region) { nil }
          let(:address_region_code) { nil }

          it 'will be invalid if postcode and line 1 present' do
            expect(building.errors[:address_region].present?).to eq true
          end

          it 'will have the correct error message' do
            expect(building.errors[:address_region].first).to eq 'You must select a region for your address'
          end
        end

        context 'when neither are blank' do
          it 'will be valid if postcode and line 1 present' do
            expect(building.errors[:address_region].present?).to eq false
          end
        end
      end

      describe 'when saving address_postcode' do
        context 'when postcode is blank' do
          before do
            building.address_postcode = nil
          end

          context 'when manually adding an address' do
            it 'will be invalid' do
              building.valid? :add_address
              expect(building.errors.details.dig(:address_postcode).first.dig(:error)).to eq :blank
            end
          end

          context 'when creating a building' do
            it 'will be invalid' do
              building.valid? :new
              expect(building.errors.details.dig(:address_postcode).first.dig(:error)).to eq :blank
            end
          end

          context 'when editing a building' do
            it 'will be invalid' do
              building.valid? :new
              expect(building.errors.details.dig(:address_postcode).first.dig(:error)).to eq :blank
            end
          end
        end

        context 'when saving postcode_format' do
          context 'when totally bad format' do
            it 'will be invalid' do
              building.address_postcode = 'something'
              building.valid? :building_details
              expect(building.errors.details.dig(:address_postcode).first.dig(:error)).to eq :invalid
            end
          end

          context 'when saved with incorrect format' do
            it 'will be invalid' do
              building.address_postcode = '1XX X11'
              building.valid? :building_details
              expect(building.errors.details.dig(:address_postcode).first.dig(:error)).to eq :invalid
            end
          end
        end
      end

      context 'when processing the address selection' do
        before do
          building.address_line_1 = nil
          building.address_postcode
          building.valid? :all
        end

        it 'will be invalid' do
          expect(building.errors.details.dig(:base).first.dig(:error)).to eq :not_selected
        end
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

  describe '#add_region_code_from_address_region' do
    subject(:building) { create(:facilities_management_building) }

    before do
      building.update(address_region: region, address_region_code: nil)
      building.add_region_code_from_address_region
    end

    context 'when zero regions are returned' do
      let(:region) { 'New York State' }

      it 'does not change the building region' do
        expect(building.address_region_code).to eq nil
      end
    end

    context 'when a region is returned' do
      let(:region) { 'Aberdeen and Aberdeenshire' }

      it 'does change the building region' do
        expect(building.address_region_code).to eq 'UKM50'
      end
    end
  end

  describe 'address methods' do
    subject(:building) { create(:facilities_management_building) }

    context 'when using full_address' do
      context 'when all parts of the address are present' do
        it 'returns the correct address' do
          expect(building.full_address).to eq '10 Mariners Court, Floor 2, Southend-On-Sea, Essex, SS31 0DR'
        end
      end

      context 'when address line 2 is not present' do
        before { building.address_line_2 = nil }

        it 'returns the correct address' do
          expect(building.full_address).to eq '10 Mariners Court, Southend-On-Sea, Essex, SS31 0DR'
        end
      end
    end

    context 'when using address_no_region' do
      context 'when all parts of the address are present' do
        it 'returns the correct address' do
          expect(building.address_no_region).to eq '10 Mariners Court, Floor 2, Southend-On-Sea, SS31 0DR'
        end
      end

      context 'when address line 2 is not present' do
        before { building.address_line_2 = nil }

        it 'returns the correct address' do
          expect(building.address_no_region).to eq '10 Mariners Court, Southend-On-Sea, SS31 0DR'
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
