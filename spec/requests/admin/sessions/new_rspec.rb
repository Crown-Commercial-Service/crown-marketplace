require 'rails_helper'

RSpec.describe 'admin login', type: :request do
  it 'verify admin login page header' do
    get facilities_management_admin_new_user_session_path
    expect(response).to render_template(:new)
    expect(response.body).to include('Sign in to your administration dashboard')
  end
end
