require 'rails_helper'
# rubocop:disable RSpec/NamedSubject
module FacilitiesManagement
  RSpec.describe BuyerDetailsController do
    let(:default_params) { { service: 'facilities_management', framework: framework } }
    let(:framework) { 'RM6232' }

    render_views

    describe 'GET edit with buyer' do
      context 'when logged in with buyer details' do
        login_fm_buyer_with_details

        before { get :edit, params: { id: subject.current_user.id } }

        it 'renders edit template' do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:edit)
        end
      end

      context 'when logged in without buyer details' do
        login_fm_buyer

        before { get :edit, params: { id: subject.current_user.id } }

        it 'renders edit template' do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:edit)
        end
      end

      context 'when the framework is not recognised' do
        login_fm_buyer_with_details

        let(:framework) { 'RM3840' }

        before { get :edit, params: { id: subject.current_user.id } }

        it 'renders the unrecognised framework page with the right http status' do
          expect(response).to render_template('home/unrecognised_framework')
          expect(response).to have_http_status(:bad_request)
        end

        it 'sets the framework variables' do
          expect(assigns(:unrecognised_framework)).to eq 'RM3840'
          expect(controller.params[:framework]).to eq Framework.facilities_management.current_framework
        end
      end
    end

    describe 'GET edit_address' do
      context 'when logged in with buyer details' do
        login_fm_buyer_with_details

        before { get :edit_address, params: { buyer_detail_id: subject.current_user.id } }

        it 'renders edit template' do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:edit_address)
        end
      end

      context 'when logged in without buyer details' do
        login_fm_buyer

        before { get :edit_address, params: { buyer_detail_id: subject.current_user.id } }

        it 'renders edit template' do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:edit_address)
        end
      end
    end

    describe 'PUT update' do
      login_fm_buyer_with_details

      context 'when updating from the edit page' do
        before { put :update, params: { id: subject.current_user.id, facilities_management_buyer_detail: { full_name: full_name } } }

        context 'when there are errors' do
          let(:full_name) { '' }

          it 'renders the edit template' do
            expect(response).to render_template(:edit)
          end
        end

        context 'when there are no errors' do
          let(:full_name) { 'Fred Flintstone' }

          it 'redirects to facilities_management_index_path' do
            expect(response).to redirect_to facilities_management_index_path(framework: framework)
          end

          it 'updates the buyer name' do
            subject.current_user.reload

            expect(subject.current_user.buyer_detail.full_name).to eq full_name
          end
        end
      end

      context 'when updating from the edit_address page' do
        before { put :update, params: { id: subject.current_user.id, context: :update_address, facilities_management_buyer_detail: { organisation_address_line_1: organisation_address_line_1 } } }

        context 'when there are errors' do
          let(:organisation_address_line_1) { '' }

          it 'renders the edit_address template' do
            expect(response).to render_template(:edit_address)
          end
        end

        context 'when there are no errors' do
          let(:organisation_address_line_1) { '9 Downing Street' }

          it 'redirects to edit_facilities_management_buyer_detail_path' do
            expect(response).to redirect_to edit_facilities_management_buyer_detail_path(framework, subject.current_user)
          end

          it 'updates the buyer name' do
            subject.current_user.reload

            expect(subject.current_user.buyer_detail.organisation_address_line_1).to eq organisation_address_line_1
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NamedSubject
