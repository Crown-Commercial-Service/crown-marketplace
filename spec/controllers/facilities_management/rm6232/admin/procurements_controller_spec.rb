require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::ProcurementsController, type: :controller do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM6232' } }

  login_fm_admin

  describe 'GET index' do
    context 'when not logged in as fm admin' do
      login_fm_buyer

      it 'redirects to the not permitted page' do
        get :index

        expect(response).to redirect_to '/facilities-management/RM6232/admin/not-permitted'
      end
    end

    context 'when the framework is not recognised' do
      let(:default_params) { { service: 'facilities_management/admin', framework: 'RM007' } }

      before { get :index }

      it 'renders the unrecognised framework page with the right http status' do
        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end

      it 'sets the framework variables' do
        expect(assigns(:unrecognised_framework)).to eq 'RM007'
        expect(controller.params[:framework]).to eq FacilitiesManagement::Framework.default_framework
      end
    end

    context 'when logged in as fm admin' do
      before do
        create_list(:facilities_management_rm6232_procurement_what_happens_next, 75)

        get :index, params: { page: page }
      end

      context 'and the page is nil' do
        let(:page) { nil }

        it 'renders the new page and sets the paginated procurements to be the first 50' do
          expect(response).to render_template(:index)

          expect(assigns(:paginated_procurements).length).to eq(50)
        end
      end

      context 'and the page is 1' do
        let(:page) { 1 }

        it 'renders the new page and sets the paginated procurements to be the first 50' do
          expect(response).to render_template(:index)

          expect(assigns(:paginated_procurements).length).to eq(50)
        end
      end

      context 'and the page is 2' do
        let(:page) { 2 }

        it 'renders the new page and sets the paginated procurements to be the last 25' do
          expect(response).to render_template(:index)

          expect(assigns(:paginated_procurements).length).to eq(25)
        end
      end

      context 'and the page is 3' do
        let(:page) { 3 }

        it 'renders the new page and sets 0 paginated procurements' do
          expect(response).to render_template(:index)

          expect(assigns(:paginated_procurements).length).to be_zero
        end
      end
    end
  end

  describe 'GET search_procurements' do
    let(:contract_name) { Faker::Name.unique.name }
    let(:contract_number) { 'RM6232-999999-2022' }
    let(:paginated_procurements) { assigns(:paginated_procurements) }

    before do
      create_list(:facilities_management_rm6232_procurement_what_happens_next, 10)
      create(:facilities_management_rm6232_procurement_what_happens_next, contract_name: contract_name, contract_number: contract_number)

      get :search_procurements, params: { search_value: search_value }, xhr: true
    end

    context 'when the search_value param is empty' do
      let(:search_value) { nil }

      it 'renders the search_procurements page' do
        expect(response).to render_template(:search_procurements)
      end

      it 'has the full list' do
        expect(paginated_procurements.length).to eq(11)
      end
    end

    context 'when the search_value param is my procurements name' do
      let(:search_value) { contract_name }

      it 'renders the search_procurements page' do
        expect(response).to render_template(:search_procurements)
      end

      it 'has a shortened list with my procurement' do
        expect(paginated_procurements.length).to eq(1)

        expect(paginated_procurements.first.contract_name).to eq contract_name
      end
    end

    context 'when the search_value param is my contracts reference number' do
      let(:search_value) { contract_number }

      it 'renders the search_procurements page' do
        expect(response).to render_template(:search_procurements)
      end

      it 'has a shortened list with my procurement' do
        expect(paginated_procurements.length).to eq(1)

        expect(paginated_procurements.first.contract_name).to eq contract_name
      end
    end

    context 'when the search_value param is a random string' do
      let(:search_value) { Faker::Name.unique.name }

      it 'renders the search_procurements page' do
        expect(response).to render_template(:search_procurements)
      end

      it 'has no procurements' do
        expect(assigns(:paginated_procurements).length).to be_zero
      end
    end
  end
end
