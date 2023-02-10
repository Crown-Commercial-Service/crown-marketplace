require 'rails_helper'

# We have a spec for both frameworks to make sure
# both work with the supplier details controller
RSpec.describe FacilitiesManagement::Admin::SupplierDetailsController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM6232' } }
  let(:supplier) { create(:facilities_management_rm6232_admin_suppliers_admin) }

  describe 'GET show' do
    context 'when logged in as an fm admin' do
      login_fm_admin

      before { get :show, params: { id: supplier_id } }

      context 'when the action is called' do
        let(:supplier_id) { supplier.id }

        it 'renders the show page' do
          expect(response).to render_template(:show)
        end

        it 'sets the supplier' do
          expect(assigns(:supplier).supplier_name).to eq supplier.supplier_name
        end
      end

      context 'when the supplier does not exist' do
        let(:supplier_id) { 'not-real-id' }

        it 'redirects to the supplier data' do
          expect(response).to redirect_to facilities_management_rm6232_admin_supplier_data_path
        end
      end
    end

    context 'when not an fm admin' do
      login_fm_buyer

      before { get :show, params: { id: supplier.id } }

      it 'redirects to not permitted page' do
        expect(response).to redirect_to '/facilities-management/RM6232/admin/not-permitted'
      end
    end
  end

  describe 'GET edit' do
    let(:supplier_id) { supplier.id }

    login_fm_admin

    render_views

    before { get :edit, params: { id: supplier_id, page: page } }

    context 'when the supplier does not exist' do
      let(:supplier_id) { 'not-real-id' }
      let(:page) { :supplier_name }

      it 'redirects to the supplier data' do
        expect(response).to redirect_to facilities_management_rm6232_admin_supplier_data_path
      end
    end

    context 'when on the supplier name page' do
      let(:page) { :supplier_name }

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end

      it 'renders the correct partial' do
        expect(response).to render_template(partial: 'facilities_management/admin/supplier_details/_supplier_name')
      end

      it 'sets the supplier' do
        expect(assigns(:supplier).supplier_name).to eq supplier.supplier_name
      end

      it 'sets the page' do
        expect(assigns(:page)).to eq page
      end
    end

    context 'when on the supplier contact information page' do
      let(:page) { :supplier_contact_information }

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end

      it 'renders the correct partial' do
        expect(response).to render_template(partial: 'facilities_management/admin/supplier_details/_supplier_contact_information')
      end

      it 'sets the supplier' do
        expect(assigns(:supplier).supplier_name).to eq supplier.supplier_name
      end

      it 'sets the page' do
        expect(assigns(:page)).to eq page
      end
    end

    context 'when on the additional supplier information page' do
      let(:page) { :additional_supplier_information }

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end

      it 'renders the correct partial' do
        expect(response).to render_template(partial: 'facilities_management/admin/supplier_details/_additional_supplier_information')
      end

      it 'sets the supplier' do
        expect(assigns(:supplier).supplier_name).to eq supplier.supplier_name
      end

      it 'sets the page' do
        expect(assigns(:page)).to eq page
      end
    end

    context 'when on the supplier address page' do
      let(:page) { :supplier_address }

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end

      it 'renders the correct partial' do
        expect(response).to render_template(partial: 'facilities_management/admin/supplier_details/_supplier_address')
      end

      it 'sets the supplier' do
        expect(assigns(:supplier).supplier_name).to eq supplier.supplier_name
      end

      it 'sets the page' do
        expect(assigns(:page)).to eq page
      end
    end

    context 'when on the supplier status page' do
      let(:page) { :supplier_status }

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end

      it 'renders the correct partial' do
        expect(response).to render_template(partial: 'facilities_management/admin/supplier_details/_supplier_status')
      end

      it 'sets the supplier' do
        expect(assigns(:supplier).supplier_name).to eq supplier.supplier_name
      end

      it 'sets the page' do
        expect(assigns(:page)).to eq page
      end
    end
  end

  describe 'PUT update' do
    login_fm_admin

    before do
      allow(FacilitiesManagement::RM6232::Admin::SupplierData::Edit).to receive(:log_change)
      allow(FacilitiesManagement::RM6232::Admin::SupplierData::Edit).to receive(:log_change).with(controller.current_user, supplier)
      put :update, params: { id: supplier.id, page: page, facilities_management_rm6232_admin_suppliers_admin: supplier_params }
    end

    context 'when updating on the supplier name page' do
      let(:page) { :supplier_name }
      let(:supplier_params) { { supplier_name: supplier_name } }

      context 'and the data is not valid' do
        let(:supplier_name) { '' }

        it 'renders the edit page' do
          expect(response).to render_template :edit
        end
      end

      context 'and the data is valid' do
        let(:supplier_name) { 'Pollyanna' }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_admin_supplier_detail_path(framework: 'RM6232')
        end

        it 'adds a log to the database' do
          expect(FacilitiesManagement::RM6232::Admin::SupplierData::Edit).to have_received(:log_change).with(controller.current_user, supplier)
        end
      end
    end

    context 'when updating on the additional supplier information page' do
      let(:page) { :additional_supplier_information }
      let(:supplier_params) { { duns: duns, registration_number: 'AB123456' } }

      context 'and the data is not valid' do
        let(:duns) { '0123456789' }

        it 'renders the edit page' do
          expect(response).to render_template :edit
        end
      end

      context 'and the data is valid' do
        let(:duns) { '123456789' }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_admin_supplier_detail_path(framework: 'RM6232')
        end

        it 'adds a log to the database' do
          expect(FacilitiesManagement::RM6232::Admin::SupplierData::Edit).to have_received(:log_change).with(controller.current_user, supplier)
        end
      end
    end

    context 'when updating on the supplier address page' do
      let(:page) { :supplier_address }
      let(:supplier_params) { { address_line_1: '3 Avery Way', address_line_2: '', address_town: 'Eastliegh', address_county: 'Anglesux', address_postcode: address_postcode } }

      context 'and the data is not valid' do
        let(:address_postcode) { 'AAA111' }

        it 'renders the edit page' do
          expect(response).to render_template :edit
        end
      end

      context 'and the data is valid' do
        let(:address_postcode) { 'AA1 1AA' }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_admin_supplier_detail_path(framework: 'RM6232')
        end

        it 'adds a log to the database' do
          expect(FacilitiesManagement::RM6232::Admin::SupplierData::Edit).to have_received(:log_change).with(controller.current_user, supplier)
        end
      end
    end

    context 'when updating on the supplier status page' do
      let(:page) { :supplier_status }
      let(:supplier_params) { { active: supplier_status } }

      context 'and the data is not valid' do
        let(:supplier_status) { '' }

        it 'renders the edit page' do
          expect(response).to render_template :edit
        end
      end

      context 'and the data is valid' do
        let(:supplier_status) { 'true' }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_admin_supplier_detail_path(framework: 'RM6232')
        end

        it 'adds a log to the database' do
          expect(FacilitiesManagement::RM6232::Admin::SupplierData::Edit).to have_received(:log_change).with(controller.current_user, supplier)
        end
      end
    end
  end
end
