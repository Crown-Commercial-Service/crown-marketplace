require 'rails_helper'

RSpec.describe FacilitiesManagementSuppliersController, type: :controller do
  describe 'GET lot1a_suppliers' do
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
