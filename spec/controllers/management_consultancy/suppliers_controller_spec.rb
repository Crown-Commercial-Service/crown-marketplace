require 'rails_helper'

RSpec.describe ManagementConsultancy::SuppliersController, type: :controller do
  let(:supplier) { build(:management_consultancy_supplier) }
  let(:suppliers) { [supplier] }
  let(:lot) { ManagementConsultancy::Lot.find_by(number: lot_number) }
  let(:services) { ManagementConsultancy::Service.all.sample(5).map(&:code) }
  let(:region_codes) { Nuts2Region.all.sample(5).map(&:code) }

  before do
    allow(ManagementConsultancy::Supplier).to receive(:offering_services_in_regions)
      .with(lot_number, services, region_codes, true).and_return(suppliers)
  end

  describe 'GET index' do
    before do
      get :index, params: params
    end

    context 'when the lot answer is lot1' do
      let(:lot_number) { '1' }

      let(:params) do
        {
          journey: 'management-consultancy',
          lot: lot_number,
          services: services,
          expenses: 'paid',
          region_codes: region_codes
        }
      end

      it 'renders the index template' do
        expect(response).to render_template('index')
      end

      it 'assigns suppliers available in lot & regions, with services' do
        expect(assigns(:suppliers)).to eq(suppliers)
      end

      it 'assigns lot to the correct lot' do
        expect(assigns(:lot)).to eq(lot)
      end

      it 'sets the back path to the choose regions question' do
        expected_path = journey_question_path(
          journey: 'management-consultancy',
          slug: 'choose-regions',
          lot: lot_number,
          services: services,
          expenses: 'paid',
          region_codes: region_codes
        )
        expect(assigns(:back_path)).to eq(expected_path)
      end
    end

    context 'when the lot answer is lot2' do
      let(:lot_number) { '2' }

      let(:params) do
        {
          journey: 'management-consultancy',
          lot: lot_number,
          services: services,
          expenses: 'paid',
          region_codes: region_codes
        }
      end

      it 'assigns lot to the correct lot' do
        expect(assigns(:lot)).to eq(lot)
      end

      it 'renders the index template' do
        expect(response).to render_template('index')
      end

      it 'assigns suppliers available in lot & regions, with services' do
        expect(assigns(:suppliers)).to eq(suppliers)
      end

      it 'sets the back path to the choose regions question' do
        expected_path = journey_question_path(
          journey: 'management-consultancy',
          slug: 'choose-regions',
          lot: lot_number,
          services: services,
          expenses: 'paid',
          region_codes: region_codes
        )
        expect(assigns(:back_path)).to eq(expected_path)
      end
    end
  end
end
