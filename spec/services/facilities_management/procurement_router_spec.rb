require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementRouter do
  let(:procurement_router) { described_class.new(id: 1, procurement_state: state, step: step) }
  let(:step) { nil }

  describe '.route' do
    context 'when the procurement is in quick search state' do
      let(:state) { 'quick_search' }

      context 'when a step has been set to regions' do
        let(:step) { 'regions' }

        it 'returns a route for the edit page' do
          expect(procurement_router.route).to eq('/facilities-management/beta/procurements/1/edit')
        end
      end

      context 'when a step has been set to services' do
        let(:step) { 'services' }

        it 'returns a route for the edit page' do
          expect(procurement_router.route).to eq('/facilities-management/beta/procurements/1/edit')
        end
      end

      context 'when a non existing step has been set' do
        let(:step) { 'fake-step' }

        it 'redirects the user to the procurement index page' do
          expect(procurement_router.route).to eq('/facilities-management/beta/procurements')
        end
      end

      context 'when no step has been set' do
        it 'redirects the user to the procurement index page' do
          expect(procurement_router.route).to eq('/facilities-management/beta/procurements')
        end
      end
    end

    context 'when the procurement is in a detailed search state' do
      let(:state) { 'detailed_search' }

      context 'when on the first step' do
        let(:step) { 'contract_name' }

        it 'returns a route for the next edit step' do
          expect(procurement_router.route).to eq('/facilities-management/beta/procurements/1/edit?step=estimated_annual_cost')
        end
      end

      context 'when on the procurement_buildings_step' do
        let(:step) { 'procurement_buildings' }

        it 'returns a route for the next step' do
          expect(procurement_router.route).to eq('/facilities-management/beta/procurements/1/edit?step=building_services')
        end
      end

      context 'when on the last step' do
        let(:procurement_building) { create(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement, id: 1)) }
        let(:procurement_router) { described_class.new(id: procurement_building.procurement.id, procurement_state: state, step: step) }
        let(:step) { 'building_services' }

        it 'returns a route for the show procurement_building page' do
          expect(procurement_router.route).to eq("/facilities-management/beta/procurement_buildings/#{procurement_building.id}")
        end
      end

      context 'when there is no current step' do
        it 'returns a route for the show page' do
          expect(procurement_router.route).to eq('/facilities-management/beta/procurements/1')
        end
      end
    end
  end

  describe '.back_link' do
    context 'when the procurement is in a detailed search state' do
      let(:state) { 'detailed_search' }

      context 'when on the first step' do
        let(:step) { 'contract_name' }

        it 'returns a route for the show page' do
          expect(procurement_router.back_link).to eq('/facilities-management/beta/procurements/1')
        end
      end

      context 'when on the last step' do
        let(:step) { 'building_services' }

        it 'returns a route for the edit page of the previous step' do
          expect(procurement_router.back_link).to eq('/facilities-management/beta/procurements/1/edit?step=procurement_buildings')
        end
      end

      context 'when there is no current step' do
        it 'returns a route for the show page' do
          expect(procurement_router.back_link).to eq('/facilities-management/beta/procurements/1')
        end
      end
    end
  end
end
