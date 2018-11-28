require 'rails_helper'

RSpec.describe FacilitiesManagement::SuppliersController, type: :controller do
  let(:supplier) { build(:facilities_management_supplier) }
  let(:suppliers) { [supplier] }
  let(:lot) { FacilitiesManagement::Lot.find_by(number: lot_number) }

  before do
    allow(FacilitiesManagement::Supplier)
      .to receive(:available_in_lot)
      .with(lot_number).and_return(suppliers)
    allow(FacilitiesManagement::Supplier)
      .to receive(:available_in_lot_and_regions)
      .with(lot_number, ['UKK4']).and_return(suppliers)
    permit_framework :facilities_management
  end

  describe 'GET index' do
    before do
      get :index, params: params
    end

    context 'when the value band is under1_5m' do
      let(:lot_number) { '1a' }
      let(:value_band) { 'under1_5m' }

      let(:params) do
        {
          journey: 'facilities-management',
          value_band: value_band,
          region_codes: ['UKK4']
        }
      end

      it 'renders the index template' do
        expect(response).to render_template('index')
      end

      it 'assigns suppliers available in lot' do
        expect(assigns(:suppliers)).to eq(suppliers)
      end

      it 'assigns lot to the correct lot' do
        expect(assigns(:lot)).to eq(lot)
      end

      it 'sets the back path to the supplier region question' do
        expected_path = journey_question_path(
          journey: 'facilities-management',
          slug: 'supplier-region',
          value_band: value_band,
          region_codes: ['UKK4']
        )
        expect(assigns(:back_path)).to eq(expected_path)
      end
    end

    context 'when the value band is under7m' do
      let(:value_band) { 'under7m' }
      let(:lot_number) { '1a' }

      let(:params) do
        {
          journey: 'facilities-management',
          value_band: value_band,
          region_codes: ['UKK4']
        }
      end

      it 'assigns lot to the correct lot' do
        expect(assigns(:lot)).to eq(lot)
      end

      it 'sets the back path to the supplier region question' do
        expected_path = journey_question_path(
          journey: 'facilities-management',
          slug: 'supplier-region',
          value_band: value_band,
          region_codes: ['UKK4']
        )
        expect(assigns(:back_path)).to eq(expected_path)
      end
    end

    context 'when the value band is under50m' do
      let(:value_band) { 'under50m' }
      let(:lot_number) { '1b' }

      let(:params) do
        {
          journey: 'facilities-management',
          value_band: value_band
        }
      end

      it 'assigns lot to the correct lot' do
        expect(assigns(:lot)).to eq(lot)
      end

      it 'sets the back path to the value band question' do
        expected_path = journey_question_path(
          journey: 'facilities-management',
          slug: 'value-band',
          value_band: value_band
        )
        expect(assigns(:back_path)).to eq(expected_path)
      end
    end

    context 'when the value band is over50m' do
      let(:value_band) { 'over50m' }
      let(:lot_number) { '1c' }

      let(:params) do
        {
          journey: 'facilities-management',
          value_band: value_band
        }
      end

      it 'assigns lot to the correct lot' do
        expect(assigns(:lot)).to eq(lot)
      end

      it 'sets the back path to the value band question' do
        expected_path = journey_question_path(
          journey: 'facilities-management',
          slug: 'value-band',
          value_band: value_band
        )
        expect(assigns(:back_path)).to eq(expected_path)
      end
    end
  end
end
