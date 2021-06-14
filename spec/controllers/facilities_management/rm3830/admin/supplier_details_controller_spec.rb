require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::SupplierDetailsController, type: :controller do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }
  let(:supplier) { FacilitiesManagement::Admin::SuppliersAdmin.find_by(supplier_name: 'Abernathy and Sons') }

  login_fm_admin

  describe 'GET index' do
    context 'when an fm amdin' do
      before { get :index }

      it 'renders the index page' do
        expect(response).to render_template(:index)
      end

      it 'sets the list of suppliers' do
        expect(assigns(:suppliers).size).to eq FacilitiesManagement::Admin::SuppliersAdmin.count
      end
    end

    context 'when not an fm admin' do
      login_fm_buyer

      before { get :index }

      it 'redirects to not permitted page' do
        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end
  end

  describe 'GET show' do
    before { get :show, params: { id: supplier.supplier_id } }

    context 'when the action is called' do
      it 'renders the show page' do
        expect(response).to render_template(:show)
      end

      it 'sets the supplier' do
        expect(assigns(:supplier).supplier_name).to eq 'Abernathy and Sons'
      end
    end
  end

  describe 'GET edit' do
    render_views

    before { get :edit, params: { id: supplier.supplier_id, page: page } }

    context 'when on the supplier name page' do
      let(:page) { :supplier_name }

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end

      it 'renders the correct partial' do
        expect(response).to render_template(partial: 'facilities_management/rm3830/admin/supplier_details/_supplier_name')
      end

      it 'sets the supplier' do
        expect(assigns(:supplier).supplier_name).to eq 'Abernathy and Sons'
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
        expect(response).to render_template(partial: 'facilities_management/rm3830/admin/supplier_details/_supplier_contact_information')
      end

      it 'sets the supplier' do
        expect(assigns(:supplier).supplier_name).to eq 'Abernathy and Sons'
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
        expect(response).to render_template(partial: 'facilities_management/rm3830/admin/supplier_details/_additional_supplier_information')
      end

      it 'sets the supplier' do
        expect(assigns(:supplier).supplier_name).to eq 'Abernathy and Sons'
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
        expect(response).to render_template(partial: 'facilities_management/rm3830/admin/supplier_details/_supplier_address')
      end

      it 'sets the supplier' do
        expect(assigns(:supplier).supplier_name).to eq 'Abernathy and Sons'
      end

      it 'sets the page' do
        expect(assigns(:page)).to eq page
      end
    end
  end

  describe 'PUT update' do
    before { put :update, params: { id: supplier.supplier_id, page: page, facilities_management_admin_suppliers_admin: supplier_params } }

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
          expect(response).to redirect_to facilities_management_rm3830_admin_supplier_detail_path
        end
      end
    end

    context 'when updating on the supplier contact information page' do
      let(:page) { :supplier_contact_information }
      let(:supplier_params) { { contact_name: contact_name, contact_email: 'fake@email.com', contact_phone: '(03456) 867 431' } }

      context 'and the data is not valid' do
        let(:contact_name) { '' }

        it 'renders the edit page' do
          expect(response).to render_template :edit
        end
      end

      context 'and the data is valid' do
        let(:contact_name) { 'Ness' }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_rm3830_admin_supplier_detail_path
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
          expect(response).to redirect_to facilities_management_rm3830_admin_supplier_detail_path
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
          expect(response).to redirect_to facilities_management_rm3830_admin_supplier_detail_path
        end
      end
    end

    context 'when updating on the supplier user page' do
      let(:user) { create(:user, roles: :supplier) }
      let(:page) { :supplier_user }
      let(:supplier_params) { { user_email: user_email } }

      context 'and the data is not valid' do
        let(:user_email) { 'AAA111' }

        it 'renders the edit page' do
          expect(response).to render_template :edit
        end
      end

      context 'and the data is valid' do
        let(:user_email) { user.email }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_rm3830_admin_supplier_detail_path
        end
      end
    end
  end
end
