require 'rails_helper'

RSpec.describe FacilitiesManagement::BuildingsHelper, type: :helper do
  let(:building) { create(:facilities_management_building, user: create(:user)) }

  describe '.should_building_details_be_open?' do
    let(:page_data) { {} }

    before do
      building.building_type = building_type
      page_data[:model_object] = building
    end

    context 'when building type is blank' do
      let(:building_type) { nil }

      it 'returns false' do
        @page_data = page_data
        expect(helper.should_building_details_be_open?).to be false
      end
    end

    context 'when the building type is "other"' do
      let(:building_type) { 'other' }

      it 'returns true' do
        @page_data = page_data
        expect(helper.should_building_details_be_open?).to be true
      end
    end

    context 'when there are errors on "other_building_type"' do
      let(:building_type) { 'General office - Customer Facing' }

      before do
        page_data[:model_object].errors.add(:other_building_type, :blank)
      end

      it 'returns true' do
        @page_data = page_data
        expect(helper.should_building_details_be_open?).to be true
      end
    end

    context 'when the building type is lower in the list of types' do
      let(:building_type) { 'Restaurant and Catering Facilities' }

      it 'returns true' do
        @page_data = page_data
        expect(helper.should_building_details_be_open?).to be true
      end
    end

    context 'when the building type is General office - customer facing' do
      let(:building_type) { 'General office - Customer Facing' }

      it 'returns false' do
        @page_data = page_data
        expect(helper.should_building_details_be_open?).to be false
      end
    end
  end
end
