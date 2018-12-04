require 'rails_helper'

RSpec.describe SupplyTeachers::DownloadsController, type: :controller, auth: true do
  describe 'GET index' do
    context 'when not logged in' do
      before do
        ensure_not_logged_in
      end

      it 'redirects to gateway page' do
        expect(get(:index)).to redirect_to(supply_teachers_gateway_path)
      end
    end
  end

  it 'responds to requests for xlsx files' do
    get :index, params: { format: 'xlsx' }

    expect(response.content_type)
      .to eq 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end
end
