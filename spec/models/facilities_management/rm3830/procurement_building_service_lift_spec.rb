require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementBuildingServiceLift do
  describe '#valid?' do
    let(:lift) { create(:facilities_management_rm3830_lift, procurement_building_service: procurement_building_service) }
    let(:procurement_building_service) { create(:facilities_management_rm3830_procurement_building_service, procurement_building: procurement_building) }
    let(:procurement_building) { create(:facilities_management_rm3830_procurement_building, procurement: procurement) }
    let(:procurement) { create(:facilities_management_rm3830_procurement, user: create(:user)) }

    before do
      lift.number_of_floors = number_of_floors
      lift.valid?
    end

    context 'when the number of floors is nil' do
      let(:number_of_floors) { nil }

      it 'is not valid' do
        expect(lift.errors.any?).to be true
      end

      it 'has the correct error message' do
        expect(lift.errors[:number_of_floors].first).to eq 'The number of floors accessed must be a whole number and greater than 0'
      end
    end

    context 'when the number of floors is 0' do
      let(:number_of_floors) { 0 }

      it 'is not valid' do
        expect(lift.errors.any?).to be true
      end

      it 'has the correct error message' do
        expect(lift.errors[:number_of_floors].first).to eq 'Enter a whole number between 1 and 999'
      end
    end

    context 'when the number of floors is 1000' do
      let(:number_of_floors) { 1000 }

      it 'is not valid' do
        expect(lift.errors.any?).to be true
      end

      it 'has the correct error message' do
        expect(lift.errors[:number_of_floors].first).to eq 'Enter a whole number between 1 and 999'
      end
    end

    context 'when the number of floors is in the range' do
      let(:number_of_floors) { 80 }

      it 'is valid' do
        expect(lift.errors.any?).to be false
      end
    end

    context 'when the number of floors is non numeric' do
      let(:number_of_floors) { 'a' }

      it 'is not valid' do
        expect(lift.errors.any?).to be true
      end

      it 'has the correct error message' do
        expect(lift.errors[:number_of_floors].first).to eq 'The number of floors accessed must be a whole number and greater than 0'
      end
    end

    context 'when the number of floors is a decimal' do
      let(:number_of_floors) { 1.5 }

      it 'is not valid' do
        expect(lift.errors.any?).to be true
      end

      it 'has the correct error message' do
        expect(lift.errors[:number_of_floors].first).to eq 'Enter a whole number between 1 and 999'
      end
    end
  end
end
