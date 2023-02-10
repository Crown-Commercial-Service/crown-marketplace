require 'rails_helper'

RSpec.describe Api::V2::PostcodesController do
  login_fm_buyer

  describe 'can retrieve a postcode' do
    it 'bad postcode' do
      postcode = 'X11 1XX'
      get :show, params: { id: postcode }
      expect(response.header['Content-Type']).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq(200).or eq(404)
      # expect(json_response['error']).to eq('Postcode not found')
    end
  end
end
