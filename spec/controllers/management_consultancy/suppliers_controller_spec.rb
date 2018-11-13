require 'rails_helper'

module ManagementConsultancy
  RSpec.describe SuppliersController, type: :controller do
    let(:supplier) { build(:management_consultancy_supplier) }
    let(:suppliers) { [supplier] }

    before do
      allow(Supplier).to receive(:available_in_lot)
        .with(lot_number).and_return(suppliers)
    end

    describe 'GET index' do
      before do
        get :index, params: params
      end

      context 'when the lot is lot1' do
        let(:lot) { 'lot1' }
        let(:lot_number) { '1' }

        let(:params) do
          {
            journey: 'management-consultancy',
            lot: lot,
          }
        end

        it 'renders the index template' do
          expect(response).to render_template('index')
        end

        it 'assigns suppliers available in lot' do
          expect(assigns(:suppliers)).to eq(suppliers)
        end

        it 'sets the back path to the choose lot question' do
          expected_path = journey_question_path(
            journey: 'management-consultancy',
            slug: 'choose-lot',
            lot: lot
          )
          expect(assigns(:back_path)).to eq(expected_path)
        end
      end

      context 'when the lot is lot2' do
        let(:lot) { 'lot2' }
        let(:lot_number) { '2' }

        let(:params) do
          {
            journey: 'management-consultancy',
            lot: lot
          }
        end

        it 'sets the back path to the choose lot question' do
          expected_path = journey_question_path(
            journey: 'management-consultancy',
            slug: 'choose-lot',
            lot: lot
          )
          expect(assigns(:back_path)).to eq(expected_path)
        end
      end
    end
  end
end
