require 'rails_helper'
require 'api/v2/postcodes_controller'

RSpec.describe Api::V2::PostcodesController, type: :controller do
  describe 'can retrieve a postcode' do
    it 'bad postcode' do
      postcode = 'X11 1XX'
      get :show, params: { id: postcode }
      expect(response.header['Content-Type']).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq(200).or eq(404)
    end

    it 'will get 8 results' do
      postcode = 'EH15 2BA'
      get :show, params: { id: postcode }
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq(200)
      expect(json_response['result'].length).to eq(8)
    end

    it 'will see a summary line in the results' do
      postcode = 'EH15 2BA'
      get :show, params: { id: postcode }
      json_response = JSON.parse(response.body)
      expect(json_response['result'][0]['summary_line'].present?).to eq(true)
    end
  end
end
