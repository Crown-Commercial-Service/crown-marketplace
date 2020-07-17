require 'rails_helper'

# rubocop:disable RSpec/AnyInstance
# rubocop:disable Metrics/BlockLength

RSpec.describe FacilitiesManagement::DeleteProcurement do
  let(:procurement) { create(:facilities_management_procurement, contract_name: 'New search') }
  let(:procurement_building) { create(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement)) }

  describe 'deleting a procurement in search stages' do
    before do
      allow_any_instance_of(procurement.class).to receive(:delete_procurement)
    end

    context 'when deleting a quick search' do
      before do
        procurement.update(aasm_state: 'quick_search')
        procurement.delete_procurement
        procurement.destroy
      end

      it 'will delete the search' do
        expect { procurement.reload }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'will not find the id' do
        expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).to be_nil
      end
    end

    context 'when deleting a detailed search' do
      before do
        procurement.update(aasm_state: 'detailed_search')
        procurement.delete_procurement
        procurement.destroy
      end

      it 'will not find the procurement in the procurements table' do
        expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).to be_nil
      end

      it 'will not find the procurement in the procurement_buildings table' do
        expect(FacilitiesManagement::ProcurementBuilding.where(id: procurement.id)).to be_nil
      end

      it 'will not find the procurement in the procurement_buildings_services table' do
        expect(FacilitiesManagement::ProcurementBuildingService.where(id: procurement_building.id)).to be_nil
      end
    end

    context 'when deleting a search at choose a contract value stage' do
      before do
        procurement.update(aasm_state: 'choose_contract_value')
        procurement.delete_procurement
        procurement.destroy
      end

      it 'will not find the procurement in the procurements table' do
        expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).to be_nil
      end

      it 'will not find the procurement in the procurement_buildings table' do
        expect(FacilitiesManagement::ProcurementBuilding.find_by(id: procurement.id)).to be_nil
      end

      it 'will not find the procurement in the procurement_buildings_services table' do
        expect(FacilitiesManagement::ProcurementBuildingService.find_by(id: procurement_building.id)).to be_nil
      end
    end

    context 'when deleting a search in results' do
      
      before do

        procurement.update(aasm_state: 'results')
        procurement.delete_procurement
        procurement.destroy
      end

      it 'will not find the procurement in the procurements table' do
        expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).to be_nil
      end

      it 'will not find any procurement_buildings procurement for the procurement' do
        expect(FacilitiesManagement::ProcurementBuilding.find_by(id: procurement.id)).to be_nil
      end

      it 'will not find any procurement_buildings_services for the procurement' do
        expect(FacilitiesManagement::ProcurementBuildingService.find_by(id: procurement_building.id)).to be_nil
      end

      it 'will not find any procurement_suppliers for the procurement' do
        expect(FacilitiesManagement::ProcurementSupplier.find_by(procurement_id: procurement.id)).to be_nil
      end
      
      it 'will not find any FrozenRateCards for the procurement' do
        expect(CCS::FM::FrozenRateCard.find_by(facilities_management_procurement_id: procurement.id)).to be_nil
      end

      it 'will not find any FrozenRates for the procurement' do
        expect(CCS::FM::FrozenRate.find_by(facilities_management_procurement_id: procurement.id)).to be_nil
      end
    end
  end

  describe 'deleting a procurement in da_draft' do

    before do
      allow_any_instance_of(procurement.class).to receive(:delete_procurement)
      procurement.update(aasm_state: 'da_draft')
      procurement.delete_procurement
      procurement.destroy
    end

    context 'when in the da_draft state' do 

      it 'will not find the procurement in the procurements table' do
        expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).to be_nil
      end

      it 'will not find the procurement in the procurement_buildings table' do
        expect(FacilitiesManagement::ProcurementBuilding.find_by(id: procurement.id)).to be_nil
      end

      it 'will not find the procurement in the procurement_buildings_services table' do
        expect(FacilitiesManagement::ProcurementBuildingService.find_by(id: procurement_building.id)).to be_nil
      end

      it 'will not find any procurement_suppliers for the procurement' do
        expect(FacilitiesManagement::ProcurementSupplier.find_by(procurement_id: procurement.id)).to be_nil
      end
      
      it 'will not find any FrozenRateCards for the procurement' do
        expect(CCS::FM::FrozenRateCard.find_by(facilities_management_procurement_id: procurement.id)).to be_nil
      end

      it 'will not find any FrozenRates for the procurement' do
        expect(CCS::FM::FrozenRate.find_by(facilities_management_procurement_id: procurement.id)).to be_nil
      end
    end
  end

    context 'when on the contract_details page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'contract_details')
        procurement.delete_procurement
        procurement.destroy
      end

      it 'will delete the procurement' do
        expect { procurement.reload }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'will not find the procurement in the procurements table' do
        expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).to be_nil
      end

      it 'will not find the procurement in the procurement_buildings table' do
        expect(FacilitiesManagement::ProcurementBuilding.find_by(id: procurement.id)).to be_nil
      end

      it 'will not find the procurement in the procurement_buildings_services table' do
        expect(FacilitiesManagement::ProcurementBuildingService.find_by(id: procurement_building.id)).to be_nil
      end

      it 'will not find any procurement_suppliers for the procurement' do
        expect(FacilitiesManagement::ProcurementSupplier.find_by(procurement_id: procurement.id)).to be_nil
      end
      
      it 'will not find any FrozenRateCards for the procurement' do
        expect(CCS::FM::FrozenRateCard.find_by(facilities_management_procurement_id: procurement.id)).to be_nil
      end

      it 'will not find any FrozenRates for the procurement' do
        expect(CCS::FM::FrozenRate.find_by(facilities_management_procurement_id: procurement.id)).to be_nil
      end
    end
  end
# rubocop:enable RSpec/AnyInstance
# rubocop:enable Metrics/BlockLength