require 'rails_helper'
# rubocop:disable RSpec/NamedSubject
module FacilitiesManagement
  RSpec.describe BuyerDetailsController, type: :controller do
    render_views

    describe 'GET #buyer_details without details' do
      login_fm_buyer_with_details

      it 'renders edit template' do
        get :show, params: { id: subject.current_user.id }
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end
    end

    describe 'GET #buyer_details edit_address' do
      login_fm_buyer_with_details

      it 'renders edit template' do
        get :edit_address, params: { buyer_detail_id: subject.current_user.id }
        expect(response).to render_template(:edit_address)
      end
    end

    describe '#PUT' do
      login_fm_buyer_with_details

      it 'will render edit' do
        put :update, params: { id: subject.current_user.id, facilities_management_buyer_detail: { full_name: '' } }
        expect(response).to have_http_status(:ok)
      end

      it 'will redirect to buyer account' do
        put :update, params: { id: subject.current_user.id, facilities_management_buyer_detail: { full_name: 'name', job_title: 'title', telephone_number: '309343', organisation_name: 'org',
                                                                                                  organisation_address_line_1: 'line1',
                                                                                                  organisation_address_line_2: 'line2',
                                                                                                  organisation_address_town: 'line3',
                                                                                                  organisation_address_county: 'line4',
                                                                                                  organisation_address_postcode: 'SW1A 1AA',
                                                                                                  central_government: 'central' } }
        expect(response).to redirect_to(facilities_management_path)
      end
    end
  end
end
# rubocop:enable RSpec/NamedSubject
