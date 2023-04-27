require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::SublotServicesController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }
  let(:supplier) { FacilitiesManagement::RM3830::Admin::SuppliersAdmin.find_by(supplier_name: 'Abernathy and Sons') }
  let(:supplier_id) { supplier.supplier_id }

  login_fm_admin

  before do
    supplier.update(lot_data: {
                      '1a': { regions: ['UKC1', 'UKC2', 'UKD1'], services: ['A.7', 'A.12'] },
                      '1b': { regions: ['UKC1', 'UKC2'], services: ['A.7', 'A.12'] },
                      '1c': { regions: ['UKC1', 'UKC2'], services: ['A.7', 'A.12'] }
                    })
  end

  describe 'GET edit' do
    context 'when checking permissions' do
      context 'when an fm amdin' do
        before { get :edit, params: { supplier_framework_datum_id: supplier_id, lot: '1a' } }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when not an fm admin' do
        login_fm_buyer

        before { get :edit, params: { supplier_framework_datum_id: supplier_id, lot: '1a' } }

        it 'redirects to not permitted page' do
          expect(response).to redirect_to '/facilities-management/RM3830/admin/not-permitted'
        end
      end
    end

    context 'when viewing the edit page' do
      before { get :edit, params: { supplier_framework_datum_id: supplier_id, lot: lot_number } }

      render_views

      context 'and the lot is 1a' do
        let(:lot_number) { '1a' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'renders the correct partial' do
          expect(response).to render_template(partial: 'facilities_management/rm3830/admin/sublot_services/_services_prices_and_variances')
        end
      end

      context 'and the lot is 1b' do
        let(:lot_number) { '1b' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'renders the correct partial' do
          expect(response).to render_template(partial: 'facilities_management/rm3830/admin/sublot_services/_services')
        end

        it 'assigns the sublot region name' do
          expect(assigns(:lot_name)).to eq 'Sub-lot 1b services'
        end
      end

      context 'and the lot is 1c' do
        let(:lot_number) { '1c' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'renders the correct partial' do
          expect(response).to render_template(partial: 'facilities_management/rm3830/admin/sublot_services/_services')
        end

        it 'assigns the sublot region name' do
          expect(assigns(:lot_name)).to eq 'Sub-lot 1c services'
        end
      end

      context 'and the lot does not exist' do
        let(:lot_number) { '1e' }

        it 'redirect to admin home page' do
          expect(response).to redirect_to facilities_management_rm3830_admin_path
        end
      end
    end
  end

  describe 'PUT update' do
    # rubocop:disable RSpec/NestedGroups
    context 'when the framework is live' do
      include_context 'and RM3830 is live'

      context 'when updating the data for lot 1a' do
        let(:checked_services) { ['C.1', 'D.4'] }
        let(:data) { { 'C.1': { 'Direct Award Discount (%)': '1.0', 'Call Centre Operations (£)': '12.0' }, 'G.4': { 'Direct Award Discount (%)': '0.5', 'Special Schools (£)': '4.6789' } } }
        let(:rate) { { 'M.141': '0.1123', 'B.1': '0.35' } }

        before { put :update, params: { supplier_framework_datum_id: supplier_id, lot: '1a', checked_services: checked_services, data: data, rate: rate } }

        context 'when updating the service selection for lot 1a' do
          it 'redirects to the supplier_framework_data_path' do
            expect(response).to redirect_to facilities_management_rm3830_admin_supplier_framework_data_path
          end

          it 'updates the services correctly' do
            supplier.reload
            expect(supplier.lot_data['1a']['services']).to eq checked_services
          end
        end

        context 'and the service discount and prices are updated' do
          let(:latest_rate_card) { FacilitiesManagement::RM3830::RateCard.latest }

          context 'and the data is valid' do
            it 'redirects to the supplier_framework_data_path' do
              expect(response).to redirect_to facilities_management_rm3830_admin_supplier_framework_data_path
            end

            it 'updates the discount data correctly' do
              expect(latest_rate_card[:data][:Discounts][supplier_id.to_sym][:'C.1'][:'Disc %']).to eq 1.0
              expect(latest_rate_card[:data][:Discounts][supplier_id.to_sym][:'G.4'][:'Disc %']).to eq 0.5
            end

            it 'updates the discount prices data correctly' do
              expect(latest_rate_card[:data][:Prices][supplier_id.to_sym][:'C.1'][:'Call Centre Operations']).to eq 12.0
              expect(latest_rate_card[:data][:Prices][supplier_id.to_sym][:'G.4'][:'Special Schools']).to eq 4.6789
            end
          end

          context 'and the data is not valid' do
            let(:data) { { 'C.1': { 'Direct Award Discount (%)': '1.0', 'Call Centre Operations (£)': 'TARDIS' }, 'G.4': { 'Direct Award Discount (%)': '1.005', 'Special Schools (£)': 'Doctor' } } }

            it 'renders the edit page' do
              expect(response).to render_template(:edit)
            end

            it 'has the correct errors' do
              expect(assigns(:invalid_services)).to match('C.1' => { 'Call Centre Operations (£)' => { value: 'TARDIS', error_type: 'not_a_number' } }, 'G.4' => { 'Direct Award Discount (%)' => { value: '1.005', error_type: 'less_than_or_equal_to' }, 'Special Schools (£)' => { value: 'Doctor', error_type: 'not_a_number' } })
            end
          end
        end

        context 'and the variance is updated' do
          let(:latest_rate_card) { FacilitiesManagement::RM3830::RateCard.latest }

          context 'and the data is valid' do
            it 'redirects to the supplier_framework_data_path' do
              expect(response).to redirect_to facilities_management_rm3830_admin_supplier_framework_data_path
            end

            it 'updated the variances correctly' do
              expect(latest_rate_card[:data][:Variances][supplier_id.to_sym][:'Corporate Overhead %']).to eq 0.1123
              expect(latest_rate_card[:data][:Variances][supplier_id.to_sym][:'Mobilisation Cost (DA %)']).to eq 0.35
            end
          end

          context 'and the data is not valid' do
            let(:rate) { { 'M.141': '0.1123', 'B.1': '1.0001' } }

            it 'renders the edit page' do
              expect(response).to render_template(:edit)
            end

            it 'has the correct errors' do
              expect(assigns(:invalid_services)).to match('B.1' => { value: '1.0001', error_type: 'less_than_or_equal_to' })
            end
          end
        end
      end

      context 'when updating the checkboxes for lots 1b and 1c' do
        before { put :update, params: { supplier_framework_datum_id: supplier_id, lot: '1b', checked_services: services } }

        context 'when updating the data with services' do
          let(:services) { ['C.1', 'D.4'] }

          it 'redirects to the supplier_framework_data_path' do
            expect(response).to redirect_to facilities_management_rm3830_admin_supplier_framework_data_path
          end

          it 'updates the services correctly' do
            supplier.reload
            expect(supplier.lot_data['1b']['services']).to eq services
          end
        end

        context 'when updating the data without services' do
          let(:services) { [] }

          it 'redirects to the supplier_framework_data_path' do
            expect(response).to redirect_to facilities_management_rm3830_admin_supplier_framework_data_path
          end

          it 'updates the services correctly' do
            supplier.reload
            expect(supplier.lot_data['1b']['services']).to eq services
          end
        end
      end
    end
    # rubocop:enable RSpec/NestedGroups

    context 'when the framework has expired' do
      before { put :update, params: { supplier_framework_datum_id: supplier_id, lot: lot_number } }

      context 'when updating the data for lot 1a' do
        let(:lot_number) { '1a' }

        it 'redirects to the edit page' do
          expect(response).to redirect_to edit_facilities_management_rm3830_admin_supplier_framework_datum_sublot_service_path
        end
      end

      context 'when updating the data for lot 1b' do
        let(:lot_number) { '1b' }

        it 'redirects to the edit page' do
          expect(response).to redirect_to edit_facilities_management_rm3830_admin_supplier_framework_datum_sublot_service_path
        end
      end

      context 'when updating the data for lot 1c' do
        let(:lot_number) { '1c' }

        it 'redirects to the edit page' do
          expect(response).to redirect_to edit_facilities_management_rm3830_admin_supplier_framework_datum_sublot_service_path
        end
      end
    end
  end
end
