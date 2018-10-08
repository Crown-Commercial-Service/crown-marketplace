require 'rails_helper'

RSpec.describe BranchesController, type: :controller do
  describe 'GET index' do
    let(:branches) { %i[first_branch second_branch] }

    before do
      allow(Branch).to receive(:all).and_return(branches)
    end

    it 'assigns @branches' do
      get :index
      expect(assigns(:branches)).to eq(branches)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end
end
