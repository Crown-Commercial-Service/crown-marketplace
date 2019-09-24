require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementRouter do
  let(:procurement_router) { described_class.new(id: 1, step: step) }

  describe '.route' do
    context 'when on the first step' do
      let(:step) { 'a' }

      it 'returns a route for the next edit step' do
        expect(procurement_router.route).to eq('/facilities-management/beta/procurements/1/edit?step=b')
      end
    end

    context 'when on the last step' do
      let(:step) { 'b' }

      it 'returns a route for the show page' do
        expect(procurement_router.route).to eq('/facilities-management/beta/procurements/1')
      end
    end

    context 'when there is no current step' do
      let(:step) { nil }

      it 'returns a route for the show page' do
        expect(procurement_router.route).to eq('/facilities-management/beta/procurements/1')
      end
    end
  end
end
