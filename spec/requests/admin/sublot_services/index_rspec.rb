require 'rails_helper'

RSpec.describe 'admin sublot data services prices', type: :request do
  it 'verify page displayed' do
    get '/facilities-management/beta/admin/sublot-services/ca57bf4c-e8a5-468a-95f4-39fcf730c770/1b'
    expect(response).to redirect_to facilities_management_admin_gateway_path
  end
end
