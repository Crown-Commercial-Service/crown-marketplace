require 'rails_helper'

RSpec.describe FacilitiesManagement::DeleteProcurement do
  describe 'deleting a procurement in search stages' do
    context 'when deleting a quick search' do
      let(:procurement) { create(:facilities_management_procurement_no_procurement_buildings, contract_name: 'New search') }

      before do
        procurement.update(aasm_state: 'quick_search')
      end

      context 'when the procurement has not been deleted' do
        it 'will find the procurement' do
          expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).not_to be_nil
        end
      end

      context 'when the procurement has not been deleted' do
        before do
          described_class.delete_procurement(procurement)
        end

        it 'will not find the procurement' do
          expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).to be_nil
        end
      end
    end

    context 'when deleting a detailed search' do
      let(:procurement) { create(:facilities_management_procurement, contract_name: 'New search') }
      let!(:procurement_building_id) { procurement.procurement_buildings.first.id }

      before do
        procurement.update(aasm_state: 'detailed_search')
      end

      context 'when the procurement has not been deleted' do
        it 'will find the procurement in the procurements table' do
          expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).not_to be_nil
        end

        it 'will find procurement_buildings for the procurement' do
          expect(FacilitiesManagement::ProcurementBuilding.where(facilities_management_procurement_id: procurement.id).empty?).to be false
        end

        it 'will find the procurement_building_services for the procurement' do
          expect(FacilitiesManagement::ProcurementBuildingService.where(facilities_management_procurement_building_id: procurement_building_id).empty?).to be false
        end
      end

      context 'when the procurement has been deleted' do
        before do
          described_class.delete_procurement(procurement)
        end

        it 'will not find the procurement in the procurements table' do
          expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).to be_nil
        end

        it 'will not find any procurement_buildings for the procurement' do
          expect(FacilitiesManagement::ProcurementBuilding.where(facilities_management_procurement_id: procurement.id).empty?).to be true
        end

        it 'will not find any procurement_building_services for the procurement' do
          expect(FacilitiesManagement::ProcurementBuildingService.where(facilities_management_procurement_building_id: procurement_building_id).empty?).to be true
        end
      end
    end

    context 'when deleting a search in results' do
      let(:procurement) { create(:facilities_management_procurement, contract_name: 'New search') }
      let!(:procurement_building_id) { procurement.procurement_buildings.first.id }

      before do
        procurement.update(aasm_state: 'results')
        procurement.send(:copy_fm_rates_to_frozen)
        procurement.send(:copy_fm_rate_cards_to_frozen)
        create(:facilities_management_procurement_supplier, procurement: procurement)
      end

      context 'when the procurement has not been deleted' do
        it 'will find the procurement, procurement_buildings and procurement_buildings_services for the procurement' do
          expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).not_to be_nil
          expect(FacilitiesManagement::ProcurementBuilding.where(facilities_management_procurement_id: procurement.id).empty?).to be false
          expect(FacilitiesManagement::ProcurementBuildingService.where(facilities_management_procurement_building_id: procurement_building_id).empty?).to be false
        end

        it 'will find procurement_suppliers for the procurement' do
          expect(FacilitiesManagement::ProcurementSupplier.where(facilities_management_procurement_id: procurement.id).empty?).to be false
        end

        it 'will find FrozenRateCards for the procurement' do
          expect(CCS::FM::FrozenRateCard.where(facilities_management_procurement_id: procurement.id).empty?).to be false
        end

        it 'will find FrozenRates for the procurement' do
          expect(CCS::FM::FrozenRate.where(facilities_management_procurement_id: procurement.id).empty?).to be false
        end
      end

      context 'when the procurement has been deleted' do
        before do
          described_class.delete_procurement(procurement)
        end

        it 'will not find the procurement, procurement_buildings, procurement_buildings_services for the procurement' do
          expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).to be_nil
          expect(FacilitiesManagement::ProcurementBuilding.where(facilities_management_procurement_id: procurement.id).empty?).to be true
          expect(FacilitiesManagement::ProcurementBuildingService.where(facilities_management_procurement_building_id: procurement_building_id).empty?).to be true
        end

        it 'will not find any procurement_suppliers for the procurement' do
          expect(FacilitiesManagement::ProcurementSupplier.where(facilities_management_procurement_id: procurement.id).empty?).to be true
        end

        it 'will not find any FrozenRateCards for the procurement' do
          expect(CCS::FM::FrozenRateCard.where(facilities_management_procurement_id: procurement.id).empty?).to be true
        end

        it 'will not find any FrozenRates for the procurement' do
          expect(CCS::FM::FrozenRate.where(facilities_management_procurement_id: procurement.id).empty?).to be true
        end
      end
    end
  end

  describe 'deleting a procurement in da_draft' do
    context 'when on the contract_details page' do
      let(:procurement) { create(:facilities_management_procurement_with_contact_details, contract_name: 'New search') }
      let!(:procurement_building_id) { procurement.procurement_buildings.first.id }

      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'contract_details')
        procurement.send(:copy_fm_rates_to_frozen)
        procurement.send(:copy_fm_rate_cards_to_frozen)
      end

      context 'when the procurement has not been deleted' do
        it 'will find the procurement, procurement_buildings and procurement_buildings_services for the procurement' do
          expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).not_to be_nil
          expect(FacilitiesManagement::ProcurementBuilding.where(facilities_management_procurement_id: procurement.id).empty?).to be false
          expect(FacilitiesManagement::ProcurementBuildingService.where(facilities_management_procurement_building_id: procurement_building_id).empty?).to be false
        end

        it 'will find procurement_suppliers, FrozenRateCards and FrozenRates for the procurement' do
          expect(FacilitiesManagement::ProcurementSupplier.where(facilities_management_procurement_id: procurement.id).empty?).to be false
          expect(CCS::FM::FrozenRateCard.where(facilities_management_procurement_id: procurement.id).empty?).to be false
          expect(CCS::FM::FrozenRate.where(facilities_management_procurement_id: procurement.id).empty?).to be false
        end

        it 'will not find any contact details for the procurement' do
          expect(FacilitiesManagement::ProcurementContactDetail.where(facilities_management_procurement_id: procurement.id).empty?).to be false
        end
      end

      context 'when the procurement has been deleted' do
        before do
          described_class.delete_procurement(procurement)
        end

        it 'will not find the procurement, procurement_buildings, procurement_buildings_services for the procurement' do
          expect(FacilitiesManagement::Procurement.find_by(id: procurement.id)).to be_nil
          expect(FacilitiesManagement::ProcurementBuilding.where(facilities_management_procurement_id: procurement.id).empty?).to be true
          expect(FacilitiesManagement::ProcurementBuildingService.where(facilities_management_procurement_building_id: procurement_building_id).empty?).to be true
        end

        it 'will not find procurement_suppliers, FrozenRateCards and FrozenRates for the procurement' do
          expect(FacilitiesManagement::ProcurementSupplier.where(facilities_management_procurement_id: procurement.id).empty?).to be true
          expect(CCS::FM::FrozenRateCard.where(facilities_management_procurement_id: procurement.id).empty?).to be true
          expect(CCS::FM::FrozenRate.where(facilities_management_procurement_id: procurement.id).empty?).to be true
        end

        it 'will not find any contact details for the procurement' do
          expect(FacilitiesManagement::ProcurementContactDetail.where(facilities_management_procurement_id: procurement.id).empty?).to be true
        end
      end
    end
  end
end
