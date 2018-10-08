require 'rails_helper'

RSpec.describe BranchesController, type: :controller do
  describe 'GET index' do
    context 'when postcode is missing' do
      let(:branches) { %i[first_branch second_branch] }

      before do
        allow(Branch).to receive(:all).and_return(branches)
      end

      it 'assigns all branches to @branches' do
        get :index
        expect(assigns(:branches)).to eq(branches)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template('index')
      end
    end

    context 'when postcode is blank' do
      it 'redirects to search' do
        get :index, params: { postcode: '' }
        expect(response).to redirect_to(search_path)
      end
    end

    context 'when postcode parsing fails' do
      before do
        get :index, params: { postcode: 'nonsense' }
      end

      it 'redirects to search' do
        expect(response).to redirect_to(search_path)
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Postcode is invalid'
      end
    end

    context 'when postcode geocoding fails' do
      before do
        Geocoder::Lookup::Test.add_stub(
          'WC2B 6TE', [{ 'coordinates' => nil }]
        )
        get :index, params: { postcode: 'WC2B 6TE' }
      end

      it 'redirects to search' do
        expect(response).to redirect_to(search_path)
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq "Couldn't find that postcode"
      end
    end
  end
end
