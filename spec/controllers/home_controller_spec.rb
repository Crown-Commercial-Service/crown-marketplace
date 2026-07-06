require 'rails_helper'

RSpec.describe HomeController do
  describe 'GET index' do
    before { get :index }

    it 'renders the index page' do
      expect(response).to render_template(:index)
    end

    it 'sets the frameworks' do
      expect(assigns(:frameworks).pluck(:id)).to eq(%w[RM6374 RM6378 RM6309 RM6360 RM6376])
    end
  end

  describe 'GET healthcheck' do
    it 'displays status information about the app' do
      get :healthcheck

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.parsed_body).to eq(
        {
          'status' => 'ok',
          'git_commit' => 'expected-git-commit'
        }
      )
    end
  end
end
