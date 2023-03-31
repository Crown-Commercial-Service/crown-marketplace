require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuildingsHelper do
  let(:building) { create(:facilities_management_building, user:) }
  let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, user:) }
  let(:procurement_building) { create(:facilities_management_rm6232_procurement_building_no_services, procurement:, building:) }
  let(:user) { create(:user) }

  before do
    @building = building
    @procurement = procurement
    @procurement_building = procurement_building
  end

  describe '.edit_page_title' do
    let(:result) { helper.edit_page_title }

    before { allow(helper).to receive(:section).and_return(section_name) }

    context 'when the section is missing_region' do
      let(:section_name) { :missing_region }

      it "returns 'Confirm your building's region'" do
        expect(result).to eq("Confirm your building's region")
      end
    end

    context 'when the section is buildings_and_services' do
      let(:section_name) { :buildings_and_services }

      it 'returns the buildings name' do
        expect(result).to eq(building.building_name)
      end
    end
  end

  describe '.building_name' do
    let(:building) { create(:facilities_management_building, user: user, building_name: 'Super building 1') }
    let(:building2) { create(:facilities_management_building, user: user, building_name: 'Super building 2') }
    let(:procurement_building2) { create(:facilities_management_rm6232_procurement_building_no_services, procurement: procurement, building: building2) }

    context 'when no procurement_building is provided' do
      it 'returns the building name' do
        expect(helper.building_name).to eq('Super building 1')
      end
    end

    context 'when the procurement_building is provided' do
      it 'returns the building name' do
        expect(helper.building_name(procurement_building2)).to eq('Super building 2')
      end
    end
  end

  describe '.regions' do
    before { allow(Postcode::PostcodeCheckerV2).to receive(:find_region).and_return([{ code: 'UKH2', region: 'Bedfordshire and Hertfordshire' }, { code: 'UKJ1', region: 'Berkshire, Buckinghamshire and Oxfordshire' }]) }

    it 'returns the region names' do
      expect(helper.regions).to eq ['Bedfordshire and Hertfordshire', 'Berkshire, Buckinghamshire and Oxfordshire']
    end
  end

  describe '.form_object' do
    let(:result) { helper.form_object }

    before { allow(helper).to receive(:section).and_return(section_name) }

    context 'when the section is missing_region' do
      let(:section_name) { :missing_region }

      it 'returns the building' do
        expect(result).to eq(building)
      end
    end

    context 'when the section is buildings_and_services' do
      let(:section_name) { :buildings_and_services }

      it 'returns the procurement building' do
        expect(result).to eq(procurement_building)
      end
    end
  end

  describe '.buildings_with_missing_regions' do
    let(:procurement_building1) { procurement.procurement_buildings.create(active: true, building: create(:facilities_management_building)) }
    let(:procurement_building2) { procurement.procurement_buildings.create(active: true, building: create(:facilities_management_building, address_region_code: nil)) }
    let(:procurement_building3) { procurement.procurement_buildings.create(active: true, building: create(:facilities_management_building)) }
    let(:procurement_building4) { procurement.procurement_buildings.create(active: true, building: create(:facilities_management_building, address_region_code: nil)) }
    let(:result) { helper.buildings_with_missing_regions }

    before do
      procurement_building1
      procurement_building2
      procurement_building3
      procurement_building4
    end

    context 'when there are buildings with missing regions' do
      it 'returns the buildings missing regions' do
        expect(result).to contain_exactly(procurement_building2, procurement_building4)
      end
    end

    context 'when there are no buildings with missing regions' do
      let(:procurement_building2) { procurement.procurement_buildings.create(active: true, building: create(:facilities_management_building)) }
      let(:procurement_building4) { procurement.procurement_buildings.create(active: true, building: create(:facilities_management_building)) }

      it 'returns the buildings missing regions' do
        expect(result).to be_empty
      end
    end
  end

  describe '.return_link' do
    let(:result) { helper.return_link }

    before do
      allow(helper).to receive(:section).and_return(section_name)
      allow(helper).to receive(:procurement_show_path).and_return('procurement_show_path')
      helper.params[:framework] = 'RM6232'
    end

    context 'when the section is missing_region' do
      let(:section_name) { :missing_region }

      it 'returns the procurement show page link' do
        expect(result).to eq('procurement_show_path')
      end
    end

    context 'when the section is buildings_and_services' do
      let(:section_name) { :buildings_and_services }

      it 'returns the procurement details link' do
        expect(result).to eq("/facilities-management/RM6232/procurements/#{procurement.id}/procurement-details/buildings-and-services")
      end
    end
  end
end
