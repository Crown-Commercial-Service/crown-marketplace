require 'rails_helper'
RSpec.describe FacilitiesManagement::BuildingsController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:found)
    end
  end

  describe '#ensure_postcode_is_valid' do
    context 'when the potcode is blank' do
      it 'returns the blank postcode' do
        expect(controller.ensure_postcode_is_valid('')).to eq ''
      end
    end

    context 'when the postcode is empty space' do
      it 'returns the blank postcode' do
        expect(controller.ensure_postcode_is_valid('  ')).to eq '  '
        expect(controller.ensure_postcode_is_valid(' ')).to eq ' '
      end
    end

    context 'when the postcode is not a valid postcode' do
      it 'returns the blank postcode' do
        postcode1 = "#{('aa1'..'zz9').to_a.sample} #{('1a'..'9z').to_a.sample}"
        postcode2 = "#{('aa11a'..'zz99z').to_a.sample} #{('1a'..'9z').to_a.sample}"
        postcode3 = "#{('aa1'..'zz9').to_a.sample} #{('1a'..'9z').to_a.sample}"
        expect(controller.ensure_postcode_is_valid(postcode1)).to eq postcode1
        expect(controller.ensure_postcode_is_valid(postcode2)).to eq postcode2
        expect(controller.ensure_postcode_is_valid(postcode3)).to eq postcode3
      end
    end

    context 'when the postcode is a valid postcode' do
      it 'returns the matching postcode' do
        postcode1 = "#{('aa1'..'zz9').to_a.sample} #{('1aa'..'9zz').to_a.sample}"
        postcode2 = "#{('aa1'..'zz9').to_a.sample} #{('1aa'..'9zz').to_a.sample}"
        expect(controller.ensure_postcode_is_valid(postcode1)).to eq postcode1
        expect(controller.ensure_postcode_is_valid(postcode2)).to eq postcode2
      end
    end
  end
end
