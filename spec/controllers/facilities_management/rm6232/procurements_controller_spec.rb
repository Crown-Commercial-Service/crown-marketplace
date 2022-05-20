require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::ProcurementsController, type: :controller do
  let(:default_params) { { service: 'facilities_management', framework: 'RM6232' } }

  login_fm_buyer_with_details

  context 'without buyer details' do
    login_fm_buyer

    it 'will redirect to buyer details' do
      get :new

      expect(response).to redirect_to edit_facilities_management_buyer_detail_path(id: controller.current_user.buyer_detail.id)
    end
  end

  describe 'GET new' do
    before { get :new, params: { annual_contract_value: 123_456, region_codes: ['UKC1'], service_codes: ['E.1'] } }

    it 'renders the correct template' do
      expect(response).to render_template('new')
    end

    it 'sets the back path and text correctly' do
      expect(assigns(:back_path)).to eq '/facilities-management/RM6232/annual-contract-value?annual_contract_value=123456&region_codes%5B%5D=UKC1&service_codes%5B%5D=E.1'
      expect(assigns(:back_text)).to eq 'Return to annual contract value'
    end

    it 'sets the suppliers' do
      expect(assigns(:suppliers).class.to_s).to eq 'FacilitiesManagement::RM6232::Supplier::ActiveRecord_Relation'
    end

    it 'sets the procurement with the correct details' do
      expect(
        assigns(:procurement).attributes.slice('user_id', 'service_codes', 'region_codes', 'annual_contract_value', 'lot_number')
      ).to eq(
        { 'user_id' => controller.current_user.id,
          'service_codes' => ['E.1'],
          'region_codes' => ['UKC1'],
          'annual_contract_value' => 123_456,
          'lot_number' => '2a' }
      )
    end
  end

  describe 'POST create' do
    let(:options) { {} }

    before { post :create, params: { facilities_management_rm6232_procurement: { contract_name: contract_name, annual_contract_value: 123_456, region_codes: ['UKC1'], service_codes: ['E.1'] }, **options } }

    context 'when the record is invalid' do
      let(:contract_name) { '' }

      it 'renders the correct template' do
        expect(response).to render_template('new')
      end

      it 'sets the back path and text correctly' do
        expect(assigns(:back_path)).to eq '/facilities-management/RM6232/annual-contract-value?annual_contract_value=123456&region_codes%5B%5D=UKC1&service_codes%5B%5D=E.1'
        expect(assigns(:back_text)).to eq 'Return to annual contract value'
      end

      it 'sets the suppliers' do
        expect(assigns(:suppliers).class.to_s).to eq 'FacilitiesManagement::RM6232::Supplier::ActiveRecord_Relation'
      end

      it 'sets the procurement with the correct details' do
        expect(
          assigns(:procurement).attributes.slice('user_id', 'service_codes', 'region_codes', 'annual_contract_value', 'lot_number')
        ).to eq(
          { 'user_id' => controller.current_user.id,
            'service_codes' => ['E.1'],
            'region_codes' => ['UKC1'],
            'annual_contract_value' => 123_456,
            'lot_number' => '2a' }
        )
      end
    end

    context 'when the record is valid' do
      let(:contract_name) { 'New procurement' }

      context 'and the user clicked "Save and continue"' do
        let(:options) { { save_and_continue: 'Save and continue' } }

        it 'redirects to the show page' do
          new_procurement = FacilitiesManagement::RM6232::Procurement.all.order(created_at: :asc).first

          expect(response).to redirect_to facilities_management_rm6232_procurement_path(new_procurement.id)
        end
      end

      context 'and the user clicked "Save and return to procurements dashboard"' do
        let(:options) { { save_and_return: 'Save and return to procurements dashboard' } }

        pending 'redirects to the index page' do
          expect(response).to redirect_to facilities_management_rm6232_procurements_path
        end
      end
    end
  end

  describe 'GET show' do
    before { get :show, params: { id: procurement.id } }

    render_views

    context 'and the procurement state is what_happens_next' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_no_procurement_buildings, :skip_before_create, aasm_state: 'what_happens_next', user: controller.current_user,) }

      it 'renders the what happens next partial' do
        expect(response).to render_template(partial: '_what_happens_next')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end

      pending 'sets the back path' do
        expect(assigns(:back_path)).to eq facilities_management_rm6232_procurements_path
        expect(assigns(:back_text)).to eq 'Return to procurement dashboard'
      end
    end

    context 'when the user did not create the procurement' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_no_procurement_buildings, :skip_before_create, user: create(:user)) }

      before { get :show, params: { id: procurement.id } }

      it 'redirects to the not permitted path' do
        expect(response).to redirect_to facilities_management_rm6232_not_permitted_path
      end
    end
  end
end
