require 'rails_helper'

# rubocop:disable RSpec/AnyInstance
RSpec.describe FacilitiesManagement::DeleteProcurement do
  let(:procurement) { create(:facilities_management_procurement, contract_name: 'New search') }
  let(:procurement_building) { create(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement)) }

  describe 'deleting a procurement in search stages' do
    before do
      allow_any_instance_of(procurement.class).to receive(:delete_procurement)
    end

    context 'when deleting a quick search' do
      let(:id) { procurement.id }

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
      let(:id) { procurement.id }

      before do
        procurement.update(aasm_state: 'detailed_search')
        procurement.delete_procurement
        procurement.destroy
      end

      it 'will delete the search' do
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
    end

    context 'when deleting a search at choose a contract value stage' do
      let(:id) { procurement.id }

      before do
        procurement.update(aasm_state: 'choose_contract_value')
        procurement.delete_procurement
        procurement.destroy
      end

      it 'will delete the search' do
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
    end

    context 'when deleting a search in results' do
      let(:id) { procurement.id }

      before do
        procurement.update(aasm_state: 'results')
        procurement.delete_procurement
        procurement.destroy
      end

      it 'will delete the search' do
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
    end
  end

  describe 'deleting a procurement in da_draft' do
    let(:id) { procurement.id }

    before do
      allow_any_instance_of(procurement.class).to receive(:delete_procurement)
      procurement.update(aasm_state: 'da_draft')
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
  end

  describe 'deleting a procurement in da_draft contract journey states' do
    let(:id) { procurement.id }

    before do
      allow_any_instance_of(procurement.class).to receive(:delete_procurement)
    end

    context 'when on the pricing page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'pricing')
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
    end

    context 'when on the what_next page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'what_next')
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
    end

    context 'when on the payment_method page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'payment_method')
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
    end

    context 'when on the invoicing_contact_details page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'invoicing_contact_details')
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
    end

    context 'when on the new_invoicing_contact_details page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'new_invoicing_contact_details')
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
    end

    context 'when on the new_invoicing_address page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'new_invoicing_address')
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
    end

    context 'when on the authorised_representative page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'authorised_representative')
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
    end

    context 'when on the new_authorised_representative_details page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'new_authorised_representative_details')
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
    end

    context 'when on the new_authorised_representative_address page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'new_authorised_representative_address')
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
    end

    context 'when on the notices_contact_details page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'notices_contact_details')
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
    end

    context 'when on the new_notices_contact_details page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'new_notices_contact_details')
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
    end

    context 'when on the new_notices_address page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'new_notices_address')
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
    end

    context 'when on the security_policy_document page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'security_policy_document')
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
    end

    context 'when on the local_government_pension_scheme page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'local_government_pension_scheme')
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
    end

    context 'when on the did_you_know page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'did_you_know')
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
    end

    context 'when on the review_and_generate page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'review_and_generate')
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
    end

    context 'when on the review_and_generate_documents page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'review_and_generate_documents')
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
    end

    context 'when on the review_contract page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'review_contract')
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
    end

    context 'when on the sending page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'sending')
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
    end

    context 'when on the sending_the_contract page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'sending_the_contract')
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
    end

    context 'when on the pension_funds page' do
      before do
        procurement.update(aasm_state: 'da_draft')
        procurement.update(da_journey_state: 'pension_funds')
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
    end
  end
end
# rubocop:enable RSpec/AnyInstance
