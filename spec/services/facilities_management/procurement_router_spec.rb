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

      context 'when a non existant step has been set' do
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

      context 'when on the last step' do
        let(:step) { 'building_services' }

        it 'returns a route for the show page' do
          expect(procurement_router.route).to eq('/facilities-management/beta/procurements/1')
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
          expect(procurement_router.back_link).to eq('/facilities-management/beta/procurements/1/edit?step=contract_dates')
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
