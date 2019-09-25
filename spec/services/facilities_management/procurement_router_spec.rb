require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementRouter do
  let(:procurement_router) { described_class.new(id: 1, procurement_state: state, step: step) }
  let(:step) { nil }

  describe '.route' do
    context 'when the procurement is in quick search state' do
      let(:state) { 'quick_search' }

      it 'redirects the user to the procurement index page' do
        expect(procurement_router.route).to eq('/facilities-management/beta/procurements')
      end
    end

    context 'when the procurement is in a detailed search state' do
      let(:state) { 'detailed_search' }

      context 'when on the first step' do
        let(:step) { 'estimated_annual_cost' }

        it 'returns a route for the next edit step' do
          expect(procurement_router.route).to eq('/facilities-management/beta/procurements/1/edit?step=tupe')
        end
      end

      context 'when on the last step' do
        let(:step) { 'tupe' }

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
end
