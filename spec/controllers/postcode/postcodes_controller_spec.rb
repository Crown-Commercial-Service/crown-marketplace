require 'rails_helper'

require 'postcode/postcodes_controller'

RSpec.describe Postcode::PostcodesController, type: :controller do
  describe 'can retrieve a postcode' do
    it 'show postcode' do
      postcode = 'G32 0RP'
      get :show, params: { id: 'G32 0RP' }
      expect(response.header['Content-Type']).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['result']['postcode']).to eq(postcode)
      expect(json_response['result']['admin_district']).to eq('Glasgow City')
    end
  end
end
