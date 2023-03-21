require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::ServiceRatesController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }

  login_fm_admin

  describe 'GET edit' do
    render_views

    before { get :edit, params: { slug: rate_type } }

    context 'when viewing the average framework rates page' do
      let(:rate_type) { 'average-framework-rates' }

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end

      it 'renders the average-framework-rates partial' do
        expect(response).to render_template(partial: '_average-framework-rates')
      end
    end

    context 'when viewing the call-off benchmark rates page' do
      let(:rate_type) { 'call-off-benchmark-rates' }

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end

      it 'renders the call-off-benchmark-rates partial' do
        expect(response).to render_template(partial: '_call-off-benchmark-rates')
      end
    end
  end

  describe 'PUT update' do
    let(:rate_C1_A_id) { FacilitiesManagement::RM3830::Admin::Rates.select { |rate| rate.code == 'C.1' }.first.id }
    let(:rate_C1_C_id) { FacilitiesManagement::RM3830::Admin::Rates.select { |rate| rate.code == 'C.1' }.last.id }
    let(:rate_B1_id) { FacilitiesManagement::RM3830::Admin::Rates.select { |rate| rate.code == 'B.1' }.first.id }

    # rubocop:disable RSpec/NestedGroups
    context 'when the framework is live' do
      before { put :update, params: { slug: rate_type, rates: rates } }

      context 'when updating the average framework rates' do
        let(:rate_type) { 'average-framework-rates' }
        let(:rate_C1_A_value) { 1.456 }
        let(:rates) { { rate_C1_A_id => rate_C1_A_value, rate_B1_id => rate_B1_value } }

        context 'when the updated data is valid' do
          let(:rate_B1_value) { 0.1456 }

          it 'redirects to the home page' do
            expect(response).to redirect_to facilities_management_rm3830_admin_path
          end

          it 'updates the rates' do
            expect(FacilitiesManagement::RM3830::Admin::Rates.find(rate_C1_A_id).framework).to eq rate_C1_A_value
            expect(FacilitiesManagement::RM3830::Admin::Rates.find(rate_B1_id).framework).to eq rate_B1_value
          end
        end

        context 'when the updated data is not valid' do
          let(:rate_B1_value) { '1.2.3.4' }

          it 'renders the edit page' do
            expect(response).to render_template(:edit)
          end

          it 'adds to the errors' do
            expect(assigns(:errors).any?).to be true
          end
        end
      end

      context 'when updating the call-off benchmark rates' do
        let(:rate_type) { 'call-off-benchmark-rates' }
        let(:rate_C1_A_value) { 1.456 }
        let(:rates) { { rate_C1_A_id => rate_C1_A_value, rate_C1_C_id => rate_C1_C_value, rate_B1_id => rate_B1_value } }

        context 'when the updated data is valid' do
          let(:rate_C1_C_value) { 54.27 }
          let(:rate_B1_value) { 0.1456 }

          it 'redirects to the home page' do
            expect(response).to redirect_to facilities_management_rm3830_admin_path
          end

          it 'updates the rates' do
            expect(FacilitiesManagement::RM3830::Admin::Rates.find(rate_C1_A_id).benchmark).to eq rate_C1_A_value
            expect(FacilitiesManagement::RM3830::Admin::Rates.find(rate_C1_C_id).benchmark).to eq rate_C1_C_value
            expect(FacilitiesManagement::RM3830::Admin::Rates.find(rate_B1_id).benchmark).to eq rate_B1_value
          end
        end

        context 'when the updated data is not valid' do
          let(:rate_C1_C_value) { 'pull' }
          let(:rate_B1_value) { 'ten' }

          it 'renders the edit page' do
            expect(response).to render_template(:edit)
          end

          it 'adds to the errors' do
            expect(assigns(:errors).any?).to be true
          end
        end
      end
    end
    # rubocop:enable RSpec/NestedGroups

    context 'when the framework has expired' do
      include_context 'and RM3830 has expired'

      before { put :update, params: { slug: rate_type } }

      context 'when updating the average framework rates' do
        let(:rate_type) { 'average-framework-rates' }

        it 'redirects to the edit page' do
          expect(response).to redirect_to edit_facilities_management_rm3830_admin_service_rate_path
        end
      end

      context 'when updating the call-off benchmark rates' do
        let(:rate_type) { 'call-off-benchmark-rates' }

        it 'redirects to the edit page' do
          expect(response).to redirect_to edit_facilities_management_rm3830_admin_service_rate_path
        end
      end
    end
  end
end
