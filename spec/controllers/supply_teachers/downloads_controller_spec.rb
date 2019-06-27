require 'rails_helper'

RSpec.describe SupplyTeachers::DownloadsController, type: :controller do
  describe 'GET index' do
    context 'when not logged in' do
      it 'redirects to gateway page' do
        expect(get(:index)).to redirect_to(supply_teachers_gateway_url)
      end
    end

    context 'when logged in' do
      login_st_buyer
      it 'responds to requests for xlsx files' do
        get :index, params: { format: 'xlsx' }

        expect(response.content_type)
          .to eq 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      end
    end
  end
end
