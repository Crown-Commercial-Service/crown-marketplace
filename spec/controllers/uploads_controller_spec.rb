require 'rails_helper'

RSpec.describe UploadsController, type: :controller do
  describe 'POST create' do
    context 'when JSON is invalid' do
      it 'raises error' do
        expect do
          post :create, body: '{'
        end.to raise_error(JSON::ParserError)
      end
    end
  end
end
