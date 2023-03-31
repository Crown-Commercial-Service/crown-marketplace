require 'rails_helper'
# rubocop:disable RSpec/NestedGroups
RSpec.describe FacilitiesManagement::Building do
  describe '#building' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'default values' do
    subject(:building) { create(:facilities_management_building_defaults) }

    context 'when saving an empty record' do
      before do
        building.save(validate: false)
        building.reload
      end

      it 'default status should be Incomplete' do
        expect(building.status).to eq('Incomplete')
      end
    end
  end

  describe '#validations' do
    subject(:building) { create(:facilities_management_building) }

    context 'when everything is present' do
      it 'is valid' do
        expect(building.valid?(:all)).to be true
      end

      it '#status will be "Ready"' do
        expect(building.status).to eq 'Ready'
      end
    end

    context 'when required element not present' do
      before do
        building.building_name = nil
      end

      it '#status will be "Incomplete"' do
        building.valid?(:all)
        expect(building.status).to eq 'Incomplete'
      end
    end

    context 'when validating the building name' do
      before { building.building_name = building_name }

      context 'and it is duplicated' do
        let(:duplicate_building) { create(:facilities_management_building, user: building.user, building_name: 'sas') }
        let(:building_name) { duplicate_building.building_name }

        it 'is not valid and has the correct error message' do
          expect(building.valid?(:all)).to be false
          expect(building.errors[:building_name].first).to eq 'This building name is already in use'
        end

        it 'is taken' do
          building.valid?(:all)
          expect(building.errors.of_kind?(:building_name, :taken)).to be true
        end
      end

      context 'and it is duplicated but with added spaces' do
        let(:duplicate_building) { create(:facilities_management_building, user: building.user, building_name: 'sas') }
        let(:building_name) { "  building    name \t  \n 111 \r" }

        before { duplicate_building.update(building_name: 'building name 111') }

        it 'is not valid and has the correct error message' do
          expect(building.valid?(:all)).to be false
          expect(building.errors[:building_name].first).to eq 'This building name is already in use'
        end

        it 'is taken' do
          building.valid?(:all)
          expect(building.errors.of_kind?(:building_name, :taken)).to be true
        end
      end

      context 'and it is blank' do
        let(:building_name) { nil }

        it 'is not valid and has the correct error message' do
          expect(building.valid?(:all)).to be false
          expect(building.errors[:building_name].first).to eq 'Enter a name for your building'
        end
      end

      context 'and it is too long' do
        let(:building_name) { 'a' * 51 }

        it 'is not valid and has the correct error message' do
          expect(building.valid?(:all)).to be false
          expect(building.errors[:building_name].first).to eq 'Building name must be 50 characters or less'
        end
      end

      context 'and it is within range' do
        let(:building_name) { 'a' * 50 }

        it 'is valid' do
          expect(building.valid?(:all)).to be true
        end
      end
    end

    context 'when validating the building description' do
      before { building.description = description }

      context 'and it is too long' do
        let(:description) { 'a' * 51 }

        it 'is not valid and has the correct error message' do
          expect(building.valid?(:all)).to be false
          expect(building.errors[:description].first).to eq 'Building description must be 50 characters or less'
        end
      end

      context 'and it is within range' do
        let(:description) { 'a' * 50 }

        it 'is valid' do
          expect(building.valid?(:all)).to be true
        end
      end
    end

    context 'when validating GIA' do
      before do
        building.gia = gia
        building.valid? :building_area
      end

      context 'and it is not present' do
        let(:gia) { nil }

        it 'is invalid' do
          expect(building.valid?(:all)).to be false
          expect(building.valid?(:building_area)).to be false
        end

        it 'will have gia errors' do
          expect(building.errors.details[:gia].first[:error]).to eq :blank
        end

        it 'will have the correct error message' do
          expect(building.errors[:gia].first).to eq 'Internal area must be a number between 0 and 999,999,999'
        end
      end

      context 'and it is a float' do
        let(:gia) { 434.2 }

        it 'is invalid' do
          expect(building.valid?(:all)).to be false
          expect(building.valid?(:building_area)).to be false
        end

        it 'will have the correct error' do
          expect(building.errors.details[:gia].first[:error]).to eq :not_an_integer
        end

        it 'will have the correct error message' do
          expect(building.errors[:gia].first).to eq 'Enter a whole number for the size of internal area of this building'
        end
      end

      context 'and it is not an integer' do
        let(:gia) { 'some words' }

        it 'is invalid' do
          expect(building.valid?(:all)).to be false
          expect(building.valid?(:building_area)).to be false
        end

        it 'will have the correct error' do
          expect(building.errors.details[:gia].first[:error]).to eq :not_a_number
        end

        it 'will have the correct error message' do
          expect(building.errors[:gia].first).to eq 'Gross Internal Area (GIA) must be a whole number'
        end
      end

      context 'and it is too large' do
        let(:gia) { 1000000000 }

        it 'is invalid' do
          expect(building.valid?(:all)).to be false
          expect(building.valid?(:building_area)).to be false
        end

        it 'will have the correct error' do
          expect(building.errors.details[:gia].first[:error]).to eq :less_than_or_equal_to
        end

        it 'will have the correct error message' do
          expect(building.errors[:gia].first).to eq 'Internal area must be a number between 0 and 999,999,999'
        end
      end

      context 'and it is too small' do
        let(:gia) { -5 }

        it 'is invalid' do
          expect(building.valid?(:all)).to be false
          expect(building.valid?(:building_area)).to be false
        end

        it 'will have the correct error' do
          expect(building.errors.details[:gia].first[:error]).to eq :greater_than_or_equal_to
        end

        it 'will have the correct error message' do
          expect(building.errors[:gia].first).to eq 'Internal area must be a number between 0 and 999,999,999'
        end
      end
    end

    context 'when validating external aria' do
      before do
        building.external_area = external_area
        building.valid? :building_area
      end

      context 'when external_area is not present' do
        let(:external_area) { nil }

        it 'is invalid' do
          expect(building.valid?(:all)).to be false
          expect(building.valid?(:building_area)).to be false
        end

        it 'will have gia errors' do
          expect(building.errors.details[:external_area].first[:error]).to eq :blank
        end

        it 'will have the correct error message' do
          expect(building.errors[:external_area].first).to eq 'External area must be a number between 0 and 999,999,999'
        end
      end

      context 'when external_area is a float' do
        let(:external_area) { 434.2 }

        it 'is invalid' do
          expect(building.valid?(:all)).to be false
          expect(building.valid?(:building_area)).to be false
        end

        it 'will have the correct error' do
          expect(building.errors.details[:external_area].first[:error]).to eq :not_an_integer
        end

        it 'will have the correct error message' do
          expect(building.errors[:external_area].first).to eq 'Enter a whole number for the size of external area of this building'
        end
      end

      context 'when external_area is not an integer' do
        let(:external_area) { 'some words' }

        it 'is invalid' do
          expect(building.valid?(:all)).to be false
          expect(building.valid?(:building_area)).to be false
        end

        it 'will have the correct error' do
          expect(building.errors.details[:external_area].first[:error]).to eq :not_a_number
        end

        it 'will have the correct error message' do
          expect(building.errors[:external_area].first).to eq 'External area must be a whole number'
        end
      end

      context 'when external_area is too large' do
        let(:external_area) { 1000000000 }

        it 'is invalid' do
          expect(building.valid?(:all)).to be false
          expect(building.valid?(:building_area)).to be false
        end

        it 'will have the correct error' do
          expect(building.errors.details[:external_area].first[:error]).to eq :less_than_or_equal_to
        end

        it 'will have the correct error message' do
          expect(building.errors[:external_area].first).to eq 'External area must be a number between 0 and 999,999,999'
        end
      end

      context 'when external_area is too small' do
        let(:external_area) { -1 }

        it 'is invalid' do
          expect(building.valid?(:all)).to be false
          expect(building.valid?(:building_area)).to be false
        end

        it 'will have the correct error' do
          expect(building.errors.details[:external_area].first[:error]).to eq :greater_than_or_equal_to
        end

        it 'will have the correct error message' do
          expect(building.errors[:external_area].first).to eq 'External area must be a number between 0 and 999,999,999'
        end
      end
    end

    context 'when considering combined_external_area_and_gia_greater_than_zero' do
      before do
        building.gia = gia
        building.external_area = external_area
        building.valid? :building_area
      end

      context 'when external_area and gia are both zero' do
        let(:gia) { 0 }
        let(:external_area) { 0 }

        it 'will be invalid' do
          expect(building.errors.details[:gia].first[:error]).to eq :combined_area
          expect(building.errors.details[:external_area].first[:error]).to eq :combined_area
        end

        it 'will have the correct error messages' do
          expect(building.errors[:gia].first).to eq 'Internal area must be greater than 0, if the external area is 0'
          expect(building.errors[:external_area].first).to eq 'External area must be greater than 0, if the internal area is 0'
        end
      end

      context 'when there is an error on gia' do
        let(:gia) { nil }
        let(:external_area) { 0 }

        it 'external area will have no error messages' do
          expect(building.errors[:external_area].empty?).to be true
        end
      end

      context 'when there is an error on external_area' do
        let(:gia) { 0 }
        let(:external_area) { nil }

        it 'gia will have no error messages' do
          expect(building.errors[:gia].empty?).to be true
        end
      end
    end

    context 'when validating the building type' do
      before { building.building_type = building_type }

      context 'and it is blank' do
        let(:building_type) { nil }

        it 'is not valid and has the correct error message' do
          expect(building.valid?(:building_type)).to be false
          expect(building.errors[:building_type].first).to eq 'You must select a building type or describe your own'
        end
      end

      context 'and it is not a valid building type' do
        let(:building_type) { 'something' }

        it 'will not be valid' do
          expect(building.valid?(:building_type)).to be false
        end
      end

      context 'and it is General office - Customer Facing' do
        let(:building_type) { 'General office - Customer Facing' }

        it 'will be valid' do
          expect(building.valid?(:building_type)).to be true
        end
      end

      context 'and it is other' do
        let(:building_type) { 'other' }

        before { building.other_building_type = other_building_type }

        context 'when the other_building_type is blank' do
          let(:other_building_type) { nil }

          it 'will be invalid and have the correct error message' do
            expect(building.valid?(:building_type)).to be false
            expect(building.errors[:other_building_type].first).to eq 'You must enter your description of a building type'
          end
        end

        context 'when building_type set to General office - Customer Facing and there is somthing in other_building_type' do
          let(:building_type) { 'General office - Customer Facing' }
          let(:other_building_type) { 'other building type' }

          it 'will be valid' do
            expect(building.valid?(:building_type)).to be true
          end

          it 'will not save other_building_type' do
            building.save(context: :building_type)
            expect(building.other_building_type).to be_nil
          end
        end

        context 'when other_building_type contains carriage return characters' do
          let(:other_building_type) { ('a' * 140) + ("\r\n" * 10) }

          it 'will be valid' do
            expect(building.valid?(:building_type)).to be true
          end
        end

        context 'when other_building_type is more than 150 characters' do
          let(:other_building_type) { ('a' * 141) + ("\r\n" * 10) }

          it 'will not be valid and it will have the correct error message' do
            expect(building.valid?(:building_type)).to be false
            expect(building.errors[:other_building_type].first).to eq 'The description for the building type cannot be more than 150 characters'
          end
        end

        context 'when other_building_type is not blank' do
          let(:other_building_type) { 'other building type' }

          it 'will be valid' do
            expect(building.valid?(:building_type)).to be true
          end
        end
      end
    end

    context 'when validating the security type' do
      before { building.security_type = security_type }

      context 'and it is blank' do
        let(:security_type) { nil }

        it 'will be invalid and have the correct error message' do
          expect(building.valid?(:security_type)).to be false
          expect(building.errors[:security_type].first).to eq 'You must select a security clearance level'
        end
      end

      context 'and it is not a valid security type' do
        let(:security_type) { 'something' }

        it 'will not be valid' do
          expect(building.valid?(:security_type)).to be false
        end
      end

      context 'when security_type set to Baseline personnel security standard (BPSS)' do
        let(:security_type) { 'Baseline personnel security standard (BPSS)' }

        it 'will be valid' do
          expect(building.valid?(:security_type)).to be true
        end
      end

      context 'and it is other' do
        let(:security_type) { 'other' }

        before { building.other_security_type = other_security_type }

        context 'when the other_security_type is blank' do
          let(:other_security_type) { nil }

          it 'will be invalid and have the correct error message' do
            expect(building.valid?(:security_type)).to be false
            expect(building.errors[:other_security_type].first).to eq 'You must describe the security clearance level'
          end
        end

        context 'when security_type set to Baseline personnel security standard (BPSS) and there is somthing in other_security_type' do
          let(:security_type) { 'Baseline personnel security standard (BPSS)' }
          let(:other_security_type) { 'other security type' }

          it 'will be valid' do
            expect(building.valid?(:security_type)).to be true
          end

          it 'will be not save other_security_type' do
            building.save(context: :security_type)
            expect(building.other_security_type).to be_nil
          end
        end

        context 'when other_security_type contains carriage return characters' do
          let(:other_security_type) { ('a' * 140) + ("\r\n" * 10) }

          it 'will be valid' do
            expect(building.valid?(:security_type)).to be true
          end
        end

        context 'when other_security_type is more than 150 characters' do
          let(:other_security_type) { ('a' * 141) + ("\r\n" * 10) }

          it 'will not be valid and it will have the correct error message' do
            expect(building.valid?(:security_type)).to be false
            expect(building.errors[:other_security_type].first).to eq 'The description for the security clearance cannot be more than 150 characters'
          end
        end

        context 'when other_security_type is not blank' do
          let(:other_security_type) { 'other security type' }

          it 'will be valid' do
            expect(building.valid?(:security_type)).to be true
          end
        end
      end
    end

    describe 'when validating address_line_1' do
      before { building.address_line_1 = address_line_1 }

      context 'and it is blank' do
        let(:address_line_1) { nil }

        it 'will be invalid when manually adding an address' do
          building.valid? :add_address
          expect(building.errors.details[:address_line_1].first[:error]).to eq :blank
        end

        it 'will be valid if no postcode given' do
          building.address_postcode = nil
          building.valid? :all
          expect(building.errors.details[:address_line_1]).to eq []
        end

        it 'will be invalid if a postcode is given' do
          building.valid? :all
          expect(building.errors.details[:address_line_1].first[:error]).to eq :blank
        end

        it 'will have the correct error message' do
          building.valid? :all
          expect(building.errors[:address_line_1].first).to eq 'Add a building and street name'
        end
      end

      context 'and it is more than the max number of characters' do
        let(:address_line_1) { 'a' * 101 }

        it 'will be invalid when manually adding an address' do
          building.valid? :add_address
          expect(building.errors.details[:address_line_1].first[:error]).to eq :too_long
        end

        it 'will be valid if no postcode given' do
          building.address_postcode = nil
          building.valid? :all
          expect(building.errors.details[:address_line_1]).to eq []
        end

        it 'will be invalid if a postcode is given' do
          building.valid? :all
          expect(building.errors.details[:address_line_1].first[:error]).to eq :too_long
        end

        it 'will have the correct error message' do
          building.valid? :all
          expect(building.errors[:address_line_1].first).to eq 'Building and street name must be 100 characters or less'
        end
      end
    end

    describe 'when validating address_line_2' do
      before { building.address_line_2 = address_line_2 }

      context 'and it is more than the max number of characters' do
        let(:address_line_2) { 'a' * 101 }

        it 'will be invalid when manually adding an address' do
          building.valid? :add_address
          expect(building.errors.details[:address_line_2].first[:error]).to eq :too_long
        end

        it 'will be valid if no postcode given' do
          building.address_postcode = nil
          building.valid? :all
          expect(building.errors.details[:address_line_2]).to eq []
        end

        it 'will be invalid if a postcode is given' do
          building.valid? :all
          expect(building.errors.details[:address_line_2].first[:error]).to eq :too_long
        end

        it 'will have the correct error message' do
          building.valid? :all
          expect(building.errors[:address_line_2].first).to eq 'Building and street name must be 100 characters or less'
        end
      end
    end

    context 'when validating address_town' do
      before do
        building.address_town = addresss_town
        building.valid? :all
      end

      context 'and it is blank' do
        let(:addresss_town) { nil }

        it 'will be invalid' do
          expect(building.errors[:address_town].any?).to be true
        end

        it 'will have the correct error message' do
          expect(building.errors[:address_town].first).to eq 'Enter the town or city'
        end
      end

      context 'and it is too long' do
        let(:addresss_town) { 'a' * 31 }

        it 'will be invalid' do
          expect(building.errors[:address_town].any?).to be true
        end

        it 'will have the correct error message' do
          expect(building.errors[:address_town].first).to eq 'Town or city name for this building must be 30 characters or less'
        end
      end
    end

    context 'when validating address region selection' do
      before do
        building.address_region = address_region
        building.address_region_code = address_region_code
        building.valid?(:all)
      end

      let(:address_region) { 'Shropshire and Staffordshire' }
      let(:address_region_code) { 'UKG2' }

      context 'and address_region is blank' do
        let(:address_region) { nil }

        it 'will be invalid if postcode and line 1 present' do
          expect(building.errors[:address_region].present?).to be true
        end

        it 'will have the correct error message' do
          expect(building.errors[:address_region].first).to eq 'You must select a region for your address'
        end
      end

      context 'and address_region_code is blank' do
        let(:address_region_code) { nil }

        it 'will be invalid if postcode and line 1 present' do
          expect(building.errors[:address_region].present?).to be true
        end

        it 'will have the correct error message' do
          expect(building.errors[:address_region].first).to eq 'You must select a region for your address'
        end
      end

      context 'and both are blank' do
        let(:address_region) { nil }
        let(:address_region_code) { nil }

        it 'will be invalid if postcode and line 1 present' do
          expect(building.errors[:address_region].present?).to be true
        end

        it 'will have the correct error message' do
          expect(building.errors[:address_region].first).to eq 'You must select a region for your address'
        end
      end

      context 'and neither are blank' do
        it 'will be valid if postcode and line 1 present' do
          expect(building.errors[:address_region].present?).to be false
        end
      end
    end

    describe 'when validating address_postcode' do
      before { building.address_postcode = address_postcode }

      context 'and it is blank' do
        let(:address_postcode) { nil }

        context 'when manually adding an address' do
          it 'will be invalid' do
            building.valid? :add_address
            expect(building.errors.details[:address_postcode].first[:error]).to eq :blank
          end
        end

        context 'when creating a building' do
          it 'will be invalid' do
            building.valid? :new
            expect(building.errors.details[:address_postcode].first[:error]).to eq :blank
          end
        end

        context 'when editing a building' do
          it 'will be invalid' do
            building.valid? :building_details
            expect(building.errors.details[:address_postcode].first[:error]).to eq :blank
          end
        end

        it 'will have the correct error message' do
          building.valid? :add_address
          expect(building.errors[:address_postcode].first).to eq 'Enter a valid postcode, like AA1 1AA'
        end
      end

      context 'when validating postcode_format' do
        before { building.valid?(:building_details) }

        context 'and the format is wrong' do
          let(:address_postcode) { 'something' }

          it 'will be invalid and have the correct error message' do
            expect(building.errors.details[:address_postcode].first[:error]).to eq :invalid
            expect(building.errors[:address_postcode].first).to eq 'Enter a valid postcode, like AA1 1AA'
          end
        end

        context 'and the format is invalid' do
          let(:address_postcode) { '1XX X11' }

          it 'will be invalid and have the correct error message' do
            expect(building.errors.details[:address_postcode].first[:error]).to eq :invalid
            expect(building.errors[:address_postcode].first).to eq 'Enter a valid postcode, like AA1 1AA'
          end
        end
      end
    end

    context 'when processing the address selection' do
      before do
        building.address_line_1 = nil
        building.valid? :all
      end

      it 'will be invalid' do
        expect(building.errors.details[:base].first[:error]).to eq :not_selected
      end
    end
  end

  describe '#building_standard' do
    subject(:building) { create(:facilities_management_building) }

    before { building.building_type = building_type }

    context 'when the building is a standard type' do
      context 'and it is General office - Customer Facing' do
        let(:building_type) { 'General office - Customer Facing' }

        it 'returns STANDARD' do
          expect(building.building_standard).to eq 'STANDARD'
        end
      end

      context 'and it is Call Centre Operations' do
        let(:building_type) { 'Call Centre Operations' }

        it 'returns STANDARD' do
          expect(building.building_standard).to eq 'STANDARD'
        end
      end

      context 'and it is Primary School' do
        let(:building_type) { 'Primary School' }

        it 'returns STANDARD' do
          expect(building.building_standard).to eq 'STANDARD'
        end
      end

      context 'and it is Restaurant and Catering Facilities' do
        let(:building_type) { 'Restaurant and Catering Facilities' }

        it 'returns STANDARD' do
          expect(building.building_standard).to eq 'STANDARD'
        end
      end

      context 'and it is Special Schools' do
        let(:building_type) { 'Special Schools' }

        it 'returns STANDARD' do
          expect(building.building_standard).to eq 'STANDARD'
        end
      end

      context 'and it is Universities and Colleges' do
        let(:building_type) { 'Universities and Colleges' }

        it 'returns STANDARD' do
          expect(building.building_standard).to eq 'STANDARD'
        end
      end

      context 'and it is Community - Doctors, Dentist, Health Clinic' do
        let(:building_type) { 'Community - Doctors, Dentist, Health Clinic' }

        it 'returns STANDARD' do
          expect(building.building_standard).to eq 'STANDARD'
        end
      end

      context 'and it is Nursing and Care Homes' do
        let(:building_type) { 'Nursing and Care Homes' }

        it 'returns STANDARD' do
          expect(building.building_standard).to eq 'STANDARD'
        end
      end
    end

    context 'when the building is not a standard type' do
      context 'and it is Nuclear Facilities' do
        let(:building_type) { 'Nuclear-Facilities' }

        it 'returns NON-STANDARD' do
          expect(building.building_standard).to eq 'NON-STANDARD'
        end
      end

      context 'and it is Fitness-or-Training-Establishments' do
        let(:building_type) { 'Fitness-or-Training-Establishments' }

        it 'returns NON-STANDARD' do
          expect(building.building_standard).to eq 'NON-STANDARD'
        end
      end

      context 'and it is List-X-Property' do
        let(:building_type) { 'List-X-Property' }

        it 'returns NON-STANDARD' do
          expect(building.building_standard).to eq 'NON-STANDARD'
        end
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
        expect(building.address_region_code).to be_nil
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
          expect(building.full_address).to eq '17 Sailors road, Floor 2, Southend-On-Sea, Essex, SS84 6VF'
        end
      end

      context 'when address line 2 is not present' do
        before { building.address_line_2 = nil }

        it 'returns the correct address' do
          expect(building.full_address).to eq '17 Sailors road, Southend-On-Sea, Essex, SS84 6VF'
        end
      end
    end

    context 'when using address_no_region' do
      context 'when all parts of the address are present' do
        it 'returns the correct address' do
          expect(building.address_no_region).to eq '17 Sailors road, Floor 2, Southend-On-Sea, SS84 6VF'
        end
      end

      context 'when address line 2 is not present' do
        before { building.address_line_2 = nil }

        it 'returns the correct address' do
          expect(building.address_no_region).to eq '17 Sailors road, Southend-On-Sea, SS84 6VF'
        end
      end
    end
  end

  describe '.standard_building_type?' do
    let(:building) { create(:facilities_management_building, building_type:) }

    described_class::BUILDING_TYPES[0..11].pluck(:id).each do |type|
      context "when the building type is #{type}" do
        let(:building_type) { type }

        it 'returns true' do
          expect(building.standard_building_type?).to be true
        end
      end
    end

    described_class::BUILDING_TYPES[12..].pluck(:id).each do |type|
      context "when the building type is #{type}" do
        let(:building_type) { type }

        it 'returns false' do
          expect(building.standard_building_type?).to be false
        end
      end
    end

    context 'when the building type is other' do
      let(:building_type) { 'other' }

      it 'returns false' do
        expect(building.standard_building_type?).to be false
      end
    end

    context 'when the building type is unexpected' do
      let(:building_type) { 'Mechonis field' }

      it 'returns false' do
        expect(building.standard_building_type?).to be false
      end
    end
  end

  describe '.reselect_region' do
    RSpec::Matchers.define_negated_matcher :not_change, :change

    subject(:building) { create(:facilities_management_building) }

    let(:returned_regions) { [] }

    before do
      allow(Postcode::PostcodeCheckerV2).to receive(:find_region).and_return(returned_regions)
      building.assign_attributes(address_postcode:)
    end

    context 'when there are errors' do
      let(:address_postcode) { nil }

      it 'does not change the region' do
        expect { building.valid?(:add_address) }.to(
          not_change(building, :address_region_code)
          .and(not_change(building, :address_region))
        )
      end
    end

    context 'when the address postcode has not changed' do
      let(:address_postcode) { building.address_postcode }

      it 'does not change the region' do
        expect { building.valid?(:add_address) }.to(
          not_change(building, :address_region_code)
          .and(not_change(building, :address_region))
        )
      end
    end

    context 'when 0 regions are returned' do
      let(:address_postcode) { 'ST16 1AA' }

      it 'changes the region to be nil' do
        expect { building.valid?(:add_address) }.to(
          change(building, :address_region_code).from('UKH1').to(nil)
          .and(change(building, :address_region).from('Essex').to(nil))
        )
      end
    end

    context 'when multiple regions are returned' do
      let(:address_postcode) { 'ST16 1AA' }
      let(:returned_regions) { [{ code: 'UKH2', region: 'Bedfordshire and Hertfordshire' }, { code: 'UKJ1', region: 'Berkshire, Buckinghamshire and Oxfordshire' }] }

      it 'changes the region to be nil' do
        expect { building.valid?(:add_address) }.to(
          change(building, :address_region_code).from('UKH1').to(nil)
          .and(change(building, :address_region).from('Essex').to(nil))
        )
      end
    end

    context 'when 1 region is returned' do
      let(:address_postcode) { 'ST16 1AA' }
      let(:returned_regions) { [{ code: 'UKJ1', region: 'Berkshire, Buckinghamshire and Oxfordshire' }] }

      it 'changes the region to be the found region' do
        expect { building.valid?(:add_address) }.to(
          change(building, :address_region_code).from('UKH1').to('UKJ1')
          .and(change(building, :address_region).from('Essex').to('Berkshire, Buckinghamshire and Oxfordshire'))
        )
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
