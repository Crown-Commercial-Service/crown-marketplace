require 'rails_helper'
require 'postcode/postcodes_controller'

RSpec.describe Postcode::PostcodesController, type: :controller do
  describe 'can retrieve a postcode' do
    it 'bad postcode' do
      postcode = 'X11 1XX'
      get :show, params: { id: postcode }
      expect(response.header['Content-Type']).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq(404)
      # expect(json_response['error']).to eq('Postcode not found')
    end
  end
end
