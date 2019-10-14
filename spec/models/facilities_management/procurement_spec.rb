require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurement, type: :model do
  subject(:procurement) { build(:facilities_management_procurement, user: user) }

  let(:user) { build(:user) }

  it { is_expected.to be_valid }

  describe '#name' do
    context 'when the name is more than 100 characters' do
      it 'is expected to not be valid' do
        procurement.name = (0...101).map { ('a'..'z').to_a[rand(26)] }.join

        expect(procurement.valid?(:name)).to eq false
      end
    end

    context 'when the name is not unique' do
      let(:second_procurement) {  build(:facilities_management_procurement, name: procurement.name, user: user) }

      it 'expected to not be valid' do
        procurement.save

        expect(second_procurement.valid?(:name)).to eq false
      end
    end

    context 'when the name is not present' do
      it 'expected to not be valid' do
        procurement.name = nil
        expect(procurement.valid?(:name)).to eq false
      end
    end
  end

  describe '#contract_name' do
    context 'when the name is more than 100 characters' do
      it 'is expected to not be valid' do
        procurement.contract_name = (0...101).map { ('a'..'z').to_a[rand(26)] }.join

        expect(procurement.valid?(:contract_name)).to eq false
      end
    end

    context 'when the name is blank' do
      it 'is expected to not be valid' do
        procurement.contract_name = ''
        expect(procurement.valid?(:contract_name)).to eq false
      end
    end

    context 'when the name is correct' do
      it 'expected to be valid' do
        procurement.contract_name = 'Valid Name'
        expect(procurement.valid?(:contract_name)).to eq true
      end
    end
  end

  describe '#estimated_annual_cost' do
    context 'when estimated_cost_known is true' do
      context 'when estimated_annual_cost is present' do
        it 'expected to be valid' do
          procurement.estimated_cost_known = true
          procurement.estimated_annual_cost = 25000
          expect(procurement.valid?(:estimated_annual_cost)).to eq true
        end
      end

      context 'when the estimated_annual_cost is not present' do
        it 'expected to not be valid' do
          procurement.estimated_cost_known = true
          expect(procurement.valid?(:estimated_annual_cost)).to eq false
        end
      end
    end

    context 'when estimated_cost_known is false' do
      context 'when estimated_annual_cost is present' do
        it 'expected to be valid' do
          procurement.estimated_cost_known = false
          procurement.estimated_annual_cost = 25000
          expect(procurement.valid?(:estimated_annual_cost)).to eq true
        end
      end

      context 'when the estimated_annual_cost is not present' do
        it 'expected to be valid' do
          procurement.estimated_cost_known = false
          expect(procurement.valid?(:estimated_annual_cost)).to eq true
        end
      end
    end
  end

  describe '#procurement_buildings' do
    context 'when there are no procurement_buildings on the procurement_buildings step' do
      it 'expected to be invalid' do
        procurement.save
        expect(procurement.valid?(:procurement_buildings)).to eq false
      end
    end

    context 'when there are no active procurement_buildings on the procurement_buildings step' do
      it 'expected to be invalid' do
        procurement.save
        procurement.procurement_buildings.create(active: false)
        expect(procurement.valid?(:procurement_buildings)).to eq false
      end
    end

    context 'when there is an active procurement_building on the procurement_buildings step' do
      it 'expected to be valid' do
        procurement.save
        procurement.procurement_buildings.create(active: true)
        expect(procurement.valid?(:procurement_buildings)).to eq true
      end
    end

    context 'when the procurement_building is present with a service code' do
      it 'expected to be valid' do
        procurement.save
        procurement.procurement_buildings.create(service_codes: ['test'])
        expect(procurement.valid?(:building_services)).to eq true
      end
    end

    context 'when the procurement_building is present but without any service codes' do
      it 'expected to not be valid' do
        procurement.save
        procurement.procurement_buildings.create
        expect(procurement.procurement_buildings.first.valid?(:building_services)).to eq false
      end
    end
  end

  describe '#find_or_build_procurement_building' do
    let(:building_data) do
      {
        'name' => 'test',
        'address' => {
          'fm-address-line-1' => 'line 1',
          'fm-address-line-2' => 'line 2',
          'town' => 'town',
          'county' => 'county',
          'postcode' => 'postcode'
        }
      }
    end

    context 'when procurement building already exists' do
      before do
        procurement.save
        procurement.procurement_buildings.create(name: 'test')
      end

      it 'does not create a new one' do
        expect { procurement.find_or_build_procurement_building(building_data) }.not_to change(FacilitiesManagement::ProcurementBuilding, :count)
      end

      it 'keeps the name' do
        procurement.find_or_build_procurement_building(building_data)
        procurement_building = procurement.procurement_buildings.first
        expect(procurement_building.name).to eq building_data['name']
      end

      it 'updates its address line 1' do
        procurement.find_or_build_procurement_building(building_data)
        procurement_building = procurement.procurement_buildings.first
        expect(procurement_building.address_line_1).to eq building_data['address']['fm-address-line-1']
      end

      it 'updates its address line 2' do
        procurement.find_or_build_procurement_building(building_data)
        procurement_building = procurement.procurement_buildings.first
        expect(procurement_building.address_line_2).to eq building_data['address']['fm-address-line-2']
      end

      it 'updates its town' do
        procurement.find_or_build_procurement_building(building_data)
        procurement_building = procurement.procurement_buildings.first
        expect(procurement_building.town).to eq building_data['address']['town']
      end

      it 'updates its county' do
        procurement.find_or_build_procurement_building(building_data)
        procurement_building = procurement.procurement_buildings.first
        expect(procurement_building.county).to eq building_data['address']['county']
      end

      it 'updates its postcode' do
        procurement.find_or_build_procurement_building(building_data)
        procurement_building = procurement.procurement_buildings.first
        expect(procurement_building.postcode).to eq building_data['address']['postcode']
      end
    end

    context 'when procurement building does not exist' do
      it 'creates one' do
        procurement.save
        expect { procurement.find_or_build_procurement_building(building_data) }.to change(FacilitiesManagement::ProcurementBuilding, :count).by(1)
      end
    end
  end
end
