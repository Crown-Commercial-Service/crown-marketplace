require 'rails_helper'

RSpec.describe FacilitiesManagementSuppliersController, type: :controller do
  let(:supplier) { build(:facilities_management_supplier) }
  let(:suppliers) { [supplier] }

  before do
    allow(FacilitiesManagementSupplier).to receive(:available_in_lot)
      .with(lot_number).and_return(suppliers)
  end

  describe 'GET lot1a_suppliers' do
    let(:lot_number) { '1a' }

    before do
      get :lot1a_suppliers, params: {
        journey: 'fm',
        slug: 'lot1a-suppliers',
        value_band: 'under1_5m'
      }
    end

    it 'renders the lot1a_suppliers template' do
      expect(response).to render_template('lot1a_suppliers')
    end

    it 'assigns suppliers available in lot 1a' do
      expect(assigns(:suppliers)).to eq(suppliers)
    end

    it 'sets the back path to the value band question' do
      expected_path = journey_question_path(
        journey: 'fm',
        slug: 'value-band',
        value_band: 'under1_5m'
      )
      expect(assigns(:back_path)).to eq(expected_path)
    end
  end

  describe 'GET lot1b_suppliers' do
    let(:lot_number) { '1b' }

    before do
      get :lot1b_suppliers, params: {
        journey: 'fm',
        slug: 'lot1b-suppliers',
        value_band: 'under1_5m'
      }
    end

    it 'renders the lot1b_suppliers template' do
      expect(response).to render_template('lot1b_suppliers')
    end

    it 'assigns suppliers available in lot 1b' do
      expect(assigns(:suppliers)).to eq(suppliers)
    end

    it 'sets the back path to the value band question' do
      expected_path = journey_question_path(
        journey: 'fm',
        slug: 'value-band',
        value_band: 'under1_5m'
      )
      expect(assigns(:back_path)).to eq(expected_path)
    end
  end

  describe 'GET lot1c_suppliers' do
    let(:lot_number) { '1c' }

    before do
      get :lot1c_suppliers, params: {
        journey: 'fm',
        slug: 'lot1c-suppliers',
        value_band: 'under1_5m'
      }
    end

    it 'renders the lot1c_suppliers template' do
      expect(response).to render_template('lot1c_suppliers')
    end

    it 'assigns suppliers available in lot 1c' do
      expect(assigns(:suppliers)).to eq(suppliers)
    end

    it 'sets the back path to the value band question' do
      expected_path = journey_question_path(
        journey: 'fm',
        slug: 'value-band',
        value_band: 'under1_5m'
      )
      expect(assigns(:back_path)).to eq(expected_path)
    end
  end
end
