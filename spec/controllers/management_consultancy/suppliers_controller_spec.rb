require 'rails_helper'

RSpec.describe ManagementConsultancy::SuppliersController, type: :controller do
  let(:supplier) { create(:management_consultancy_supplier) }
  let(:suppliers) { ManagementConsultancy::Supplier.where(id: supplier.id) }
  let(:lot) { ManagementConsultancy::Lot.find_by(number: lot_number) }
  let(:services) { ManagementConsultancy::Service.all.sample(5).map(&:code) }
  let(:region_codes) { Nuts2Region.all.sample(5).map(&:code) }

  login_mc_buyer
  before do
    allow(ManagementConsultancy::Supplier).to receive(:offering_services_in_regions)
      .with(lot_number, services, region_codes).and_return(suppliers)
  end

  describe 'GET index' do
    before do
      get :index, params: params
    end

    context 'when the lot answer is MCF2 lot1' do
      let(:lot_number) { 'MCF2.1' }

      let(:params) do
        {
          journey: 'management-consultancy',
          lot: lot_number,
          services: services,
          region_codes: region_codes,
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
    end

    context 'when the lot answer is MCF2 lot2' do
      let(:lot_number) { 'MCF2.2' }

      let(:params) do
        {
          journey: 'management-consultancy',
          lot: lot_number,
          services: services,
          region_codes: region_codes,
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
    end
  end

  describe 'GET download' do
    before do
      get :download, params: params
    end

    let(:lot_number) { '1' }

    let(:params) do
      {
        journey: 'management-consultancy',
        lot: lot_number,
        services: services,
        region_codes: region_codes,
      }
    end

    it 'renders the download template' do
      expect(response).to render_template('download')
    end
  end

  describe 'GET show' do
    before do
      get :show, params: { id: supplier.id, lot: lot }
    end

    context 'when the lot answer is MCF2 lot1' do
      let(:lot_number) { 'MCF2.1' }

      it 'renders the show template' do
        expect(response).to render_template('show')
      end
    end

    context 'with no lot number set' do
      let(:lot_number) { '' }

      it 'renders the show template' do
        expect(response).to render_template('show')
      end
    end
  end
end
