require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurement, type: :model do
  subject(:procurement) { create(:facilities_management_procurement, user: user) }

  let(:user) { create(:user) }

  it { is_expected.to be_valid }

  describe '#name' do
    context 'when the name is more than 100 characters' do
      it 'is expected to not be valid' do
        procurement.name = (0...101).map { ('a'..'z').to_a[rand(26)] }.join

        expect(procurement.valid?(:name)).to eq false
      end
    end

    context 'when the name is not unique' do
      let(:second_procurement) { create(:facilities_management_procurement, name: procurement.name, user: user) }

      it 'expected to not be valid' do
        expect(second_procurement.valid?(:name)).to eq false
      end
    end

    context 'when the name has trailing and preceeding whitespace' do
      let(:third_procurement) { create(:facilities_management_procurement, name: "  #{procurement.name}  ", user: user) }

      it 'expected to remove trailing and preceeding whitespace' do
        expect(third_procurement.send(:remove_excess_whitespace_from_name)).to eq procurement.name
      end

      it 'expected not to be valid if the same name is in database without additional whitespace' do
        expect(third_procurement.valid?(:name)).to eq false
      end
    end

    context 'when the name has multiple space in the middle' do
      let(:forth_procurement) { create(:facilities_management_procurement, name: 'This   is a  test     name', user: user) }

      it 'expected to remove excess spaces' do
        expect(forth_procurement.send(:remove_excess_whitespace_from_name)).to eq 'This is a test name'
      end
    end

    context 'when the name uses invalid characters' do
      let(:fith_procurement) { create(:facilities_management_procurement, name: '!@£ $%^&* ()+=|<>,?', user: user) }

      it 'expected to be invalid' do
        expect(fith_procurement.valid?(:name)).to eq false
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
        procurement.procurement_buildings.destroy_all
        expect(procurement.valid?(:procurement_buildings)).to eq false
      end
    end

    context 'when there are no active procurement_buildings on the procurement_buildings step' do
      it 'expected to be invalid' do
        procurement.procurement_buildings.first.update(active: false)
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
        procurement_building = procurement.procurement_buildings.create(active: true)
        expect(procurement_building.valid?(:building_services)).to eq false
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
          'fm-address-town' => 'town',
          'fm-address-county' => 'county',
          'fm-address-postcode' => 'postcode'
        }
      }
    end

    let(:building_id) { 'test-building-uuid' }

    context 'when procurement building already exists' do
      before do
        procurement.save
        procurement.procurement_buildings.create(name: 'test')
      end

      it 'does not create a new one' do
        expect { procurement.find_or_build_procurement_building(building_data, building_id) }.not_to change(FacilitiesManagement::ProcurementBuilding, :count)
      end

      it 'keeps the name' do
        procurement.find_or_build_procurement_building(building_data, building_id)
        procurement_building = procurement.procurement_buildings.find_by(name: building_data['name'])
        expect(procurement_building.name).to eq building_data['name']
      end

      it 'updates its address line 1' do
        procurement.find_or_build_procurement_building(building_data, building_id)
        procurement_building = procurement.procurement_buildings.find_by(name: building_data['name'])
        expect(procurement_building.address_line_1).to eq building_data['address']['fm-address-line-1']
      end

      it 'updates its address line 2' do
        procurement.find_or_build_procurement_building(building_data, building_id)
        procurement_building = procurement.procurement_buildings.find_by(name: building_data['name'])
        expect(procurement_building.address_line_2).to eq building_data['address']['fm-address-line-2']
      end

      it 'updates its town' do
        procurement.find_or_build_procurement_building(building_data, building_id)
        procurement_building = procurement.procurement_buildings.find_by(name: building_data['name'])
        expect(procurement_building.town).to eq building_data['address']['fm-address-town']
      end

      it 'updates its county' do
        procurement.find_or_build_procurement_building(building_data, building_id)
        procurement_building = procurement.procurement_buildings.find_by(name: building_data['name'])
        expect(procurement_building.county).to eq building_data['address']['fm-address-county']
      end

      it 'updates its postcode' do
        procurement.find_or_build_procurement_building(building_data, building_id)
        procurement_building = procurement.procurement_buildings.find_by(name: building_data['name'])
        expect(procurement_building.postcode).to eq building_data['address']['fm-address-postcode']
      end
    end

    context 'when procurement building does not exist' do
      it 'creates one' do
        procurement.save
        expect { procurement.find_or_build_procurement_building(building_data, building_id) }.to change(FacilitiesManagement::ProcurementBuilding, :count).by(1)
      end
    end
  end

  describe 'validations on :all' do
    context 'when the contract name is blank' do
      it 'is expected to not be valid' do
        procurement.contract_name = ''
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the estimated_annual_cost is blank' do
      it 'is expected to not be valid' do
        procurement.estimated_cost_known = nil
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the tupe is blank' do
      it 'is expected to not be valid' do
        procurement.tupe = nil
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the initial_call_off_period is blank' do
      it 'is expected to not be valid' do
        procurement.initial_call_off_period = nil
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the initial_call_off_period is blank' do
      it 'is expected to not be valid' do
        procurement.initial_call_off_period = nil
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the initial_call_off_period is blank' do
      it 'is expected to not be valid' do
        procurement.initial_call_off_period = nil
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the tupe is selected and mobilisation length is less than 4 weeks' do
      it 'is expected to not be valid' do
        procurement.tupe = true
        procurement.mobilisation_period = 3
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the tupe is selected and mobilisation length is more than 4 weeks' do
      it 'is expected to be valid' do
        procurement.tupe = true
        procurement.mobilisation_period = 5
        expect(procurement.valid?(:all)).to eq true
      end
    end

    context 'when the there are no procurement buildings' do
      it 'is expected not to be valid' do
        procurement.procurement_buildings.destroy_all
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the there is a procurement building but no procurement_building_services' do
      it 'is expected not to be valid' do
        procurement.procurement_buildings.first.procurement_building_services.destroy_all
        expect(procurement.valid?(:all)).to eq false
      end
    end

    context 'when the there is a procurement building with two procurement_building_services' do
      it 'is expected to be valid' do
        expect(procurement.valid?(:all)).to eq true
      end
    end
  end

  describe '#valid_on_continue?' do
    context 'when valid on all' do
      it 'is expected to return true' do
        expect(procurement.valid_on_continue?).to eq true
      end
    end

    context 'when procurement not valid' do
      it 'is expected to return false' do
        procurement.initial_call_off_period = nil
        expect(procurement.valid_on_continue?).to eq false
      end
    end

    context 'when procurement_building does not have procurement_building_services' do
      it 'is expected to return false' do
        procurement.procurement_buildings.first.procurement_building_services.destroy_all
        expect(procurement.valid_on_continue?).to eq false
      end
    end
  end
end
