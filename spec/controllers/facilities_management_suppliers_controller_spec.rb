require 'rails_helper'

RSpec.describe FacilitiesManagementSuppliersController, type: :controller do
  let(:supplier) { build(:facilities_management_supplier) }
  let(:suppliers) { [supplier] }

  before do
    allow(FacilitiesManagementSupplier).to receive(:available_in_lot)
      .with(lot_number).and_return(suppliers)
  end

  describe 'GET index' do
    let(:lot_number) { '1a' }
    let(:value_band) { 'under1_5m' }

    before do
      get :index, params: {
        journey: 'fm',
        value_band: value_band
      }
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end

    it 'assigns suppliers available in lot' do
      expect(assigns(:suppliers)).to eq(suppliers)
    end

    it 'assigns lot to the correct lot' do
      expect(assigns(:lot)).to eq(lot_number)
    end

    it 'sets the back path to the value band question' do
      expected_path = journey_question_path(
        journey: 'fm',
        slug: 'value-band',
        value_band: value_band
      )
      expect(assigns(:back_path)).to eq(expected_path)
    end

    context 'when the value band is under7m' do
      let(:value_band) { 'under7m' }
      let(:lot_number) { '1a' }

      it 'assigns lot to the correct lot' do
        expect(assigns(:lot)).to eq(lot_number)
      end
    end

    context 'when the value band is under50m' do
      let(:value_band) { 'under50m' }
      let(:lot_number) { '1b' }

      it 'assigns lot to the correct lot' do
        expect(assigns(:lot)).to eq(lot_number)
      end
    end

    context 'when the value band is over50m' do
      let(:value_band) { 'over50m' }
      let(:lot_number) { '1c' }

      it 'assigns lot to the correct lot' do
        expect(assigns(:lot)).to eq(lot_number)
      end
    end
  end
end
