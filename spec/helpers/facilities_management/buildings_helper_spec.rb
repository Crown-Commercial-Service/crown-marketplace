require 'rails_helper'

RSpec.describe FacilitiesManagement::BuildingsHelper do
  let(:building) { create(:facilities_management_building, user: create(:user), **building_options) }
  let(:building_options) { {} }

  describe '.building_rows' do
    let(:building_options) { { building_name: 'asa' } }

    before { @building = building }

    # rubocop:disable RSpec/ExampleLength
    it 'returns the building data formatted as expected' do
      expect(helper.building_rows).to eq(
        {
          building_name: { value: 'asa', section: 'building_details' },
          building_description: { value: 'non-json description', section: 'building_details' },
          address: { value: '17 Sailors road', section: 'building_details' },
          region: {  value: 'Essex', section: 'building_details' },
          gia: { value: 1002, section: 'building_area' },
          external_area: { value: 4596, section: 'building_area' },
          building_type: { value: 'General office - Customer Facing', section: 'building_type' },
          security_type: { value: 'Baseline personnel security standard (BPSS)', section: 'security_type' }
        }
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe 'building_row_text' do
    let(:result) { helper.building_row_text(attribute, text) }
    let(:text) { '' }

    before { @building = building }

    context 'when the attribute is building_name' do
      let(:attribute) { :building_name }
      let(:text) { building.building_name }

      it 'returns the building name' do
        expect(result).to eq(text)
      end
    end

    context 'when the attribute is building_description' do
      let(:attribute) { :building_description }
      let(:text) { building.description }

      it 'returns the building description' do
        expect(result).to eq(text)
      end
    end

    context 'when the attribute is address' do
      let(:attribute) { :address }

      it 'returns the full address' do
        expect(result).to eq('17 Sailors road, Floor 2, Southend-On-Sea SS84 6VF')
      end
    end

    context 'when the attribute is region' do
      let(:attribute) { :region }
      let(:text) { building.address_region }

      it 'returns the building region' do
        expect(result).to eq(text)
      end
    end

    context 'when the attribute is gia' do
      let(:attribute) { :gia }

      let(:text) { building.gia }

      it 'returns the building gia' do
        expect(result).to eq('1,002 sqm')
      end
    end

    context 'when the attribute is external_area' do
      let(:attribute) { :external_area }

      let(:text) { building.external_area }

      it 'returns the building external area' do
        expect(result).to eq('4,596 sqm')
      end
    end

    # rubocop:disable RSpec/NestedGroups
    context 'when the attribute is building_type' do
      let(:attribute) { :building_type }
      let(:text) { building.building_type }

      it 'returns the building type' do
        expect(result).to eq('General office - customer facing')
      end

      context 'and the building type is other' do
        let(:text) { 'other' }
        let(:building_options) { { other_building_type: 'This is the other building type' } }

        it 'returns the building type description' do
          expect(result).to eq('Other — This is the other building type')
        end

        context 'and the description is more than 150 characters' do
          let(:building_options) { { other_building_type: 'This is the other building type and it is much more than 150 characters long. In order to do this we must, of course, add a lot of extra text. Otherwise we will not reach the threshold.' } }

          it 'returns the truncated building type description' do
            expect(result).to eq('Other — This is the other building type and it is much more than 150 characters long. In order to do this we must, of course, add a lot of extra text. Othe...')
          end
        end
      end
    end

    context 'when the attribute is security_type' do
      let(:attribute) { :security_type }
      let(:text) { building.security_type }

      it 'returns the building security type' do
        expect(result).to eq(text)
      end

      context 'and the security type is other' do
        let(:text) { 'other' }
        let(:building_options) { { other_security_type: 'This is the other security type' } }

        it 'returns the security type description' do
          expect(result).to eq('Other — This is the other security type')
        end

        context 'and the description is more than 150 characters' do
          let(:building_options) { { other_security_type: 'This is the other security type and it is much more than 150 characters long. In order to do this we must, of course, add a lot of extra text. Otherwise we will not reach the threshold.' } }

          it 'returns the truncated security type description' do
            expect(result).to eq('Other — This is the other security type and it is much more than 150 characters long. In order to do this we must, of course, add a lot of extra text. Othe...')
          end
        end
      end
    end
    # rubocop:enable RSpec/NestedGroups
  end

  describe '.section_number' do
    let(:result) { helper.section_number }

    before { allow(helper).to receive(:section).and_return(section) }

    context 'when the section is building_details' do
      let(:section) { :building_details }

      it 'returns 1' do
        expect(result).to eq(1)
      end
    end

    context 'when the section is building_area' do
      let(:section) { :building_area }

      it 'returns 2' do
        expect(result).to eq(2)
      end
    end

    context 'when the section is building_type' do
      let(:section) { :building_type }

      it 'returns 3' do
        expect(result).to eq(3)
      end
    end

    context 'when the section is security_type' do
      let(:section) { :security_type }

      it 'returns 4' do
        expect(result).to eq(4)
      end
    end

    context 'when the section is add_address' do
      let(:section) { :add_address }

      it 'returns 1' do
        expect(result).to eq(1)
      end
    end
  end

  describe '.should_building_details_be_open?' do
    let(:page_data) { {} }
    let(:building_options) { { building_type: } }
    let(:result) { helper.should_building_details_be_open? }

    before { @building = building }

    context 'when building type is blank' do
      let(:building_type) { nil }

      it 'returns false' do
        expect(result).to be false
      end
    end

    context 'when the building type is "other"' do
      let(:building_type) { 'other' }

      it 'returns true' do
        expect(result).to be true
      end
    end

    context 'when there are errors on "other_building_type"' do
      let(:building_type) { 'General office - Customer Facing' }

      before { building.errors.add(:other_building_type, :blank) }

      it 'returns true' do
        expect(result).to be true
      end
    end

    context 'when the building type is lower in the list of types' do
      let(:building_type) { 'Restaurant and Catering Facilities' }

      it 'returns true' do
        expect(result).to be true
      end
    end

    context 'when the building type is General office - customer facing' do
      let(:building_type) { 'General office - Customer Facing' }

      it 'returns false' do
        expect(result).to be false
      end
    end
  end

  describe '.select_a_region_visible?' do
    let(:building_options) { { address_line_1:, address_region: } }
    let(:result) { helper.select_a_region_visible? }

    before { @building = building }

    context 'when address_line_1 is present' do
      let(:address_line_1) { 'Something' }

      context 'when address_region is present' do
        let(:address_region) { 'Something' }

        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when address_region is not present' do
        let(:address_region) { '' }

        it 'returns true' do
          expect(result).to be true
        end
      end
    end

    context 'when address_line_1 is not present' do
      let(:address_line_1) { '' }

      context 'when address_region is present' do
        let(:address_region) { 'Something' }

        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when address_region is not present' do
        let(:address_region) { '' }

        it 'returns false' do
          expect(result).to be false
        end
      end
    end
  end

  describe '.full_region_visible?' do
    let(:result) { helper.full_region_visible? }
    let(:building_options) { { address_region: } }

    before { @building = building }

    context 'when address_region is present' do
      let(:address_region) { 'Something' }

      it 'returns true' do
        expect(result).to be true
      end
    end

    context 'when address_region is not present' do
      let(:address_region) { '' }

      it 'returns false' do
        expect(result).to be false
      end
    end
  end

  describe '.multiple_regions?' do
    before { allow(helper).to receive(:valid_regions).and_return(valid_regions) }

    let(:result) { helper.multiple_regions? }

    context 'when there are 0 regions' do
      let(:valid_regions) { [] }

      it 'returns false' do
        expect(result).to be false
      end
    end

    context 'when there is 1 region' do
      let(:valid_regions) { ['A region'] }

      it 'returns false' do
        expect(result).to be false
      end
    end

    context 'when there is more than 1 region' do
      let(:valid_regions) { ['A region', 'B region'] }

      it 'returns true' do
        expect(result).to be true
      end
    end
  end
end
