require 'rails_helper'

require 'postcode/postcodes_controller'

RSpec.describe Postcode::PostcodesController, type: :controller do
  describe 'can retrieve a postcode' do
    it 'show postcode' do
      postcode = 'G32 0RP'
      get :show, params: { id: postcode }
      expect(response.header['Content-Type']).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['result']['postcode']).to eq(postcode)
      expect(json_response['result']['admin_district']).to eq('Glasgow City')
    end

    it 'bad postcode' do
      postcode = 'X11 1XX'
      get :show, params: { id: postcode }
      expect(response.header['Content-Type']).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq(404)
      expect(json_response['error']).to eq('Postcode not found')
    end
  end

  describe 'postcode location' do
    it 'in london' do
      get :show, params: { id: 'in_london', postcode: 'SW1P 2BA' }
      expect(response.header['Content-Type']).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq(200)
      expect(json_response['result']).to eq(true)
    end

    it 'not in london' do
      get :show, params: { id: 'in_london', postcode: 'G32 0RP' }
      expect(response.header['Content-Type']).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq(200)
      expect(json_response['result']).to eq(false)
    end
  end
end
