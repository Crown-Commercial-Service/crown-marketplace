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

    context 'when there is no payment_method' do
      it 'is expected not to be valid' do
        procurement.payment_method = nil
        expect(procurement.valid(:all)).to eq false
      end
    end

    context 'when BACS_payment is a selected payment_method' do
      it 'is expected to be valid' do
        procurement.payment_method = 'BACS payment'
        expect(procurement.valid(:all)).to eq true
      end
    end

    context 'when Government_procurement_card is a selected payment_method' do
      it 'is expected to be valid' do
        procurement.payment_method = 'Government procurement card'
        expect(procurement.valid(:all)).to eq true
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

  describe '#update_building_services' do
    before do
      procurement.procurement_buildings.first.procurement_building_services.destroy_all

      procurement.procurement_buildings.first.update(service_codes: procurement.service_codes)

      procurement.service_codes = ['C.3']
    end

    it 'will remove any procurement_building_services that have a service code not included in the procurement service_codes' do
      expect { procurement.save }.to change { procurement.procurement_building_services.count }.by(-2)
    end

    it 'will remove service codes from the procurement_buildings service codes that are not selected for the procurement' do
      expect { procurement.save }.to change { procurement.procurement_buildings.first.service_codes }.from(['C.1', 'C.2']).to([])
    end
  end

  describe '#requires_service_information' do
    context 'when a building has services that require questions' do
      it 'is in the array' do
        procurement_building = create(:facilities_management_procurement_building, procurement: procurement, service_codes: ['C.5', 'E.4', 'K.8'])
        expect(procurement.procurement_buildings.requires_service_information).to eq [procurement_building]
      end
    end

    context 'when a building has no services that require questions' do
      it 'is not in the array' do
        procurement_building = create(:facilities_management_procurement_building, procurement: procurement, service_codes: ['K.11', 'K.14', 'K.8'])
        expect(procurement.procurement_buildings.requires_service_information).not_to eq [procurement_building]
      end
    end

    context 'when a building has a service that require questions' do
      it 'is in the array' do
        procurement_building = create(:facilities_management_procurement_building, procurement: procurement, service_codes: ['K.7'])
        expect(procurement.procurement_buildings.requires_service_information).to eq [procurement_building]
      end
    end

    context 'when a building has no services' do
      it 'is not in the array' do
        procurement_building = create(:facilities_management_procurement_building, procurement: procurement, service_codes: [])
        expect(procurement.procurement_buildings.requires_service_information).not_to eq [procurement_building]
      end
    end
  end

  describe '#save_eligible_suppliers' do
    context 'when no eligible suppliers' do
      it 'does not create any procurement suppliers' do
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(FacilitiesManagement::DirectAwardEligibleSuppliers).to receive(:sorted_list).and_return([])
        # rubocop:enable RSpec/AnyInstance
        expect { procurement.save_eligible_suppliers }.to change { FacilitiesManagement::ProcurementSupplier.count }.by(0)
      end
    end

    context 'when some eligible suppliers' do
      let(:da_value_test) { 865.2478374540002 }
      let(:da_value_test1) { 1517.20280381278 }
      let(:supplier_uuid) { 'eb7b05da-e52e-46a3-99ae-2cb0e6226232' }

      before do
        # rubocop:disable RSpec/AnyInstance, RSpec/SubjectStub
        allow(CCS::FM::Supplier.supplier_name('any')).to receive(:id).and_return(supplier_uuid)
        allow_any_instance_of(FacilitiesManagement::DirectAwardEligibleSuppliers).to receive(:sorted_list).and_return([[:test, da_value_test], [:test1, da_value_test1]])
        allow_any_instance_of(DirectAward).to receive(:calculate).and_return(true)
        allow(procurement).to receive(:buildings_standard).and_return('STANDARD')
        # rubocop:enable RSpec/AnyInstance, RSpec/SubjectStub
      end

      it 'creates procurement_suppliers' do
        expect { procurement.save_eligible_suppliers }.to change { FacilitiesManagement::ProcurementSupplier.count }.by(2)
      end
      it 'creates procurement_suppliers with the right direct award value' do
        procurement.save_eligible_suppliers
        expect(procurement.procurement_suppliers.first.direct_award_value).to eq da_value_test
        expect(procurement.procurement_suppliers.last.direct_award_value).to eq da_value_test1
      end
      it 'creates procurement_suppliers with the right CCS::FM::Supplier id' do
        procurement.save_eligible_suppliers
        expect(procurement.procurement_suppliers.first.supplier_id).to eq supplier_uuid
      end
    end
  end

  describe '#priced_at_framework' do
    context 'when one of the services is not priced at framework' do
      before do
        procurement.procurement_building_services.first.update(code: 'C.1', service_standard: 'A')
        procurement.procurement_building_services.last.update(code: 'C.2', service_standard: 'C')
      end

      it 'returns false' do
        expect(procurement.send(:priced_at_framework)).to eq false
      end
    end

    context 'when all services are priced at framework' do
      before do
        procurement.procurement_building_services.first.update(code: 'C.1', service_standard: 'A')
        procurement.procurement_building_services.last.update(code: 'C.2', service_standard: 'A')
      end

      it 'returns true' do
        expect(procurement.send(:priced_at_framework)).to eq true
      end
    end
  end
end
