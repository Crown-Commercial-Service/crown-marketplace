require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementRouter do
  let(:procurement_router) { described_class.new(1, state, step:) }
  let(:step) { nil }

  describe '.route' do
    context 'when the procurement is in quick search state' do
      let(:state) { 'quick_search' }

      context 'when a step has been set to regions' do
        let(:step) { 'regions' }

        it 'returns a route for the edit page' do
          expect(procurement_router.route).to eq('/facilities-management/RM3830/procurements/1/edit')
        end
      end

      context 'when a step has been set to services' do
        let(:step) { 'services' }

        it 'returns a route for the edit page' do
          expect(procurement_router.route).to eq('/facilities-management/RM3830/procurements/1/edit')
        end
      end

      context 'when a non existing step has been set' do
        let(:step) { 'fake-step' }

        it 'redirects the user to the procurement index page' do
          expect(procurement_router.route).to eq('/facilities-management/RM3830/procurements')
        end
      end

      context 'when no step has been set' do
        it 'redirects the user to the procurement index page' do
          expect(procurement_router.route).to eq('/facilities-management/RM3830/procurements')
        end
      end
    end

    context 'when the procurement is in a detailed search state' do
      let(:state) { 'detailed_search' }

      context 'when on the first step' do
        let(:step) { 'contract_name' }

        it 'returns a route for the show page' do
          expect(procurement_router.route).to eq('/facilities-management/RM3830/procurements/1')
        end
      end

      context 'when on the contract_period step' do
        let(:step) { 'contract_period' }

        it 'returns a route for the summary' do
          expect(procurement_router.route).to eq('/facilities-management/RM3830/procurements/1/procurement-details/contract_period')
        end
      end

      context 'when on the buildings step' do
        let(:step) { 'buildings' }

        it 'returns a route for the summary' do
          expect(procurement_router.route).to eq('/facilities-management/RM3830/procurements/1/procurement-details/buildings')
        end
      end

      context 'when on the buildings_and_services step' do
        let(:step) { 'buildings_and_services' }

        it 'returns a route for the summary' do
          expect(procurement_router.route).to eq('/facilities-management/RM3830/procurements/1/procurement-details/buildings_and_services')
        end
      end

      context 'when on the last step' do
        let(:procurement_building) { create(:facilities_management_rm3830_procurement_building, procurement: create(:facilities_management_rm3830_procurement, id: 1, procurement_buildings: [])) }
        let(:procurement_router) { described_class.new(procurement_building.procurement.id, state, step:) }
        let(:step) { 'building_services' }

        it 'returns a route for the show procurement_building page' do
          expect(procurement_router.route).to eq("/facilities-management/RM3830/procurement-buildings/#{procurement_building.id}")
        end
      end

      context 'when there is no current step' do
        it 'returns a route for the show page' do
          expect(procurement_router.route).to eq('/facilities-management/RM3830/procurements/1')
        end
      end
    end
  end

  describe '.back_link' do
    context 'when the procurement is in a detailed search state' do
      let(:state) { 'detailed_search' }

      context 'when on the first step' do
        let(:step) { 'security_policy_document' }

        it 'returns a route for the show page' do
          expect(procurement_router.back_link).to eq('/facilities-management/RM3830/procurements/1')
        end
      end

      context 'when there is no current step' do
        it 'returns a route for the show page' do
          expect(procurement_router.back_link).to eq('/facilities-management/RM3830/procurements/1')
        end
      end
    end
  end
end
