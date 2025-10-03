require 'rails_helper'

module FacilitiesManagement
  RSpec.describe BuyerDetailsController do
    let(:default_params) { { service: 'facilities_management', framework: framework } }
    let(:framework) { 'RM6378' }
    let(:user) { controller.current_user }

    describe 'GET show' do
      context 'when logged in with buyer details' do
        login_fm_buyer_with_details

        before { get :show, params: { id: user.id } }

        it 'renders show template' do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:show)
        end

        it 'sets buyer_detail' do
          expect(assigns(:buyer_detail)).to be_present
        end
      end

      context 'when logged in without buyer details' do
        login_fm_buyer

        before { get :show, params: { id: user.id } }

        it 'renders show template' do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:show)
        end

        it 'sets buyer_detail' do
          expect(assigns(:buyer_detail)).to be_present
        end
      end

      context 'when the framework is not recognised' do
        login_fm_buyer_with_details

        let(:framework) { 'RM3840' }

        before { get :show, params: { id: user.id } }

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

    describe 'GET edit' do
      login_fm_buyer_with_details

      before { get :edit, params: { id: user.buyer_detail.id, section: section } }

      shared_examples 'when testing a section' do
        it 'sets buyer_detail' do
          expect(assigns(:buyer_detail)).to be_present
        end

        it 'sets the back_path' do
          expect(assigns(:back_path)).to eq("/facilities-management/RM6378/buyer-details/#{user.buyer_detail.id}")
          expect(assigns(:back_text)).to eq('Your details')
        end

        context 'when considering the templates' do
          render_views

          it 'renders section partial template' do
            expect(response).to have_http_status(:ok)
            expect(response).to render_template(partial: "facilities_management/buyer_details/sections/_#{section}")
          end
        end
      end

      context 'when the section is personal_details' do
        let(:section) { :personal_details }

        include_context 'when testing a section'
      end

      context 'when the section is organisation_details' do
        let(:section) { :organisation_details }

        include_context 'when testing a section'
      end

      context 'when the section is contact_preferences' do
        let(:section) { :contact_preferences }

        include_context 'when testing a section'
      end

      context 'when the section is unexpected' do
        let(:section) { :something_else }

        it 'redirects to the show page' do
          expect(response).to redirect_to("/facilities-management/RM6378/buyer-details/#{user.buyer_detail.id}")
        end
      end
    end

    describe 'PUT update' do
      login_fm_buyer_with_details

      before { put :update, params: { id: user.buyer_detail.id, section: section, facilities_management_buyer_detail: facilities_management_buyer_detail } }

      shared_examples 'when testing a section' do
        it 'sets buyer_detail' do
          expect(assigns(:buyer_detail)).to be_present
        end

        it 'sets the back_path' do
          expect(assigns(:back_path)).to eq("/facilities-management/RM6378/buyer-details/#{user.buyer_detail.id}")
          expect(assigns(:back_text)).to eq('Your details')
        end

        context 'when it is valid' do
          it 'redirects to the show page' do
            expect(response).to redirect_to("/facilities-management/RM6378/buyer-details/#{user.buyer_detail.id}")
          end

          it 'updates the buyer details' do
            expect(user.reload.buyer_detail.attributes.deep_symbolize_keys.slice(*facilities_management_buyer_detail.keys)).to eq(facilities_management_buyer_detail)
          end
        end

        context 'when it is invalid' do
          let(:facilities_management_buyer_detail) { facilities_management_buyer_detail_invalid }

          render_views

          it 'has errors on the buyer detail' do
            expect(assigns(:buyer_detail).errors).to be_present
          end

          it 'renders section partial template' do
            expect(response).to have_http_status(:ok)
            expect(response).to render_template(partial: "facilities_management/buyer_details/sections/_#{section}")
          end
        end
      end

      context 'when the section is personal_details' do
        let(:section) { :personal_details }

        let(:facilities_management_buyer_detail) { { full_name: 'Zote the Mighty', job_title: 'Knight', telephone_number: '07123456789' } }
        let(:facilities_management_buyer_detail_invalid) { { full_name: '', job_title: '', telephone_number: '' } }

        include_context 'when testing a section'
      end

      context 'when the section is organisation_details' do
        let(:section) { :organisation_details }

        let(:facilities_management_buyer_detail) { { organisation_name: 'The Knight', organisation_address_line_1: 'Hollow Nest', organisation_address_line_2: '', organisation_address_town: 'The City', organisation_address_county: '', organisation_address_postcode: 'ST13 4AA', sector: 'defence_and_security' } }
        let(:facilities_management_buyer_detail_invalid) { { organisation_name: '', organisation_address_line_1: '', organisation_address_line_2: '', organisation_address_town: '', organisation_address_county: '', organisation_address_postcode: '', sector: '' } }

        include_context 'when testing a section'
      end

      context 'when the section is contact_preferences' do
        let(:section) { :contact_preferences }

        let(:facilities_management_buyer_detail) { { contact_opt_in: true } }
        let(:facilities_management_buyer_detail_invalid) { { contact_opt_in: '' } }

        include_context 'when testing a section'
      end

      context 'when the section is unexpected' do
        let(:section) { :something_else }

        let(:facilities_management_buyer_detail) { { full_name: 'Zote the Mighty', job_title: 'Knight', telephone_number: '07123456789' } }

        it 'redirects to the show page' do
          expect(response).to redirect_to("/facilities-management/RM6378/buyer-details/#{user.buyer_detail.id}")
        end
      end
    end
  end
end
