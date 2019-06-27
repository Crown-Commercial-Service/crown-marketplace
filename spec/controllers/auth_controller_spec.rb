require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  describe 'GET #callback' do
    before do
      OmniAuth.config.test_mode = false
      OmniAuth.config.mock_auth[:dfe] = nil
      request.env['omniauth.auth'] = {
        'info' => {
          'email' => 'dfe@example.com'
        },
        'provider' => 'dfe',
        'extra' => {
          'raw_info' => {
            'organisation' => {
              'id' => '047F32E7-FDD5-46E9-89D4-2498C2E77364',
              'name' => 'St Custard’s',
              'urn' => '900002',
              'ukprn' => '90000002',
              'category' => {
                'id' => '001',
                'name' => 'Establishment'
              },
              'type' => {
                'id' => '01',
                'name' => 'Community school'
              }
            }
          }
        }
      }

      controller.instance_eval do
        session[:requested_path] = '/REQUESTED'
      end
    end

    it 'stores the email in the session' do
      get :callback
      expect(controller.current_user.email).to eq('dfe@example.com')
    end

    it 'redirects to the page stored in the session' do
      get :callback
      expect(response).to redirect_to('/REQUESTED')
    end
  end
end
