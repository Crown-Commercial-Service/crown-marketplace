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

  describe 'GET index' do
    before do
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'what_happens_next', user: controller.current_user)
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'entering_requirements', user: controller.current_user)
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'results', user: controller.current_user)
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'further_competition', user: controller.current_user)
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'further_competition', user: controller.current_user)
      get :index
    end

    it 'renders the correct template' do
      expect(response).to render_template('index')
    end

    it 'groups up the procurements' do
      expect(assigns(:searches).length).to eq 3
      expect(assigns(:advanced_procurement_activities).length).to eq 2
    end

    it 'sets the back path' do
      expect(assigns(:back_path)).to eq facilities_management_rm6232_path
      expect(assigns(:back_text)).to eq 'Return to your account'
    end
  end

  describe 'GET show' do
    before { get :show, params: { id: procurement.id } }

    render_views

    context 'and the procurement state is what_happens_next' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_what_happens_next, user: controller.current_user) }

      it 'renders the what happens next partial' do
        expect(response).to render_template(partial: '_what_happens_next')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end

      it 'sets the back path' do
        expect(assigns(:back_path)).to eq facilities_management_rm6232_procurements_path
        expect(assigns(:back_text)).to eq 'Return to procurements dashboard'
      end
    end

    context 'and the procurement state is entering_requirements' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, user: controller.current_user) }

      it 'renders the entering requirements next partial' do
        expect(response).to render_template(partial: '_entering_requirements')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end

      it 'sets the back path' do
        expect(assigns(:back_path)).to eq facilities_management_rm6232_procurements_path
        expect(assigns(:back_text)).to eq 'Return to procurements dashboard'
      end
    end

    context 'when the user did not create the procurement' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_what_happens_next, user: create(:user)) }

      before { get :show, params: { id: procurement.id } }

      it 'redirects to the not permitted path' do
        expect(response).to redirect_to facilities_management_rm6232_not_permitted_path
      end
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
          new_procurement = FacilitiesManagement::RM6232::Procurement.order(created_at: :asc).first

          expect(response).to redirect_to facilities_management_rm6232_procurement_path(new_procurement.id)
        end
      end

      context 'and the user clicked "Save and return to procurements dashboard"' do
        let(:options) { { save_and_return: 'Save and return to procurements dashboard' } }

        it 'redirects to the index page' do
          expect(response).to redirect_to facilities_management_rm6232_procurements_path
        end
      end
    end
  end

  describe 'PUT update_show' do
    context 'and the procurement state is entering_requirements' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, user: controller.current_user) }

      before do
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(procurement.class).to receive(:valid?).and_return(safe_to_continue)
        allow_any_instance_of(procurement.class).to receive(:valid?).with(:entering_requirements).and_return(safe_to_continue)
        # rubocop:enable RSpec/AnyInstance
        put :update_show, params: { procurement_id: procurement.id }
      end

      context 'when it is safe to continue' do
        let(:safe_to_continue) { true }

        it 'sets the procurement' do
          expect(assigns(:procurement)).to eq procurement
        end

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_rm6232_procurement_path(procurement.id)
        end

        it 'updates the procurement state' do
          procurement.reload

          expect(procurement.results?).to be true
        end
      end

      context 'when it is not safe to continue' do
        let(:safe_to_continue) { false }

        render_views

        it 'sets the procurement' do
          expect(assigns(:procurement)).to eq procurement
        end

        it 'renders the entering requirements next partial' do
          expect(response).to render_template(partial: '_entering_requirements')
        end

        it 'sets the back path' do
          expect(assigns(:back_path)).to eq facilities_management_rm6232_procurements_path
          expect(assigns(:back_text)).to eq 'Return to procurements dashboard'
        end
      end
    end
  end

  describe 'GET supplier_shortlist_spreadsheet' do
    login_fm_buyer_with_details

    let(:state) { 'what_happens_next' }
    let(:procurement) { create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: state, user: controller.current_user, contract_name: 'New search') }

    before { get :supplier_shortlist_spreadsheet, params: { procurement_id: procurement.id } }

    context 'when the procurement is not in what happens next' do
      let(:state) { 'entering_requirements' }

      it 'redirects to the show page' do
        expect(response).to redirect_to facilities_management_rm6232_procurement_path(id: procurement.id)
      end
    end

    context 'when the procurement is in what happens next' do
      let(:state) { 'what_happens_next' }

      it 'does download a spreadsheet' do
        expect(response.headers['Content-Disposition']).to include 'filename="Supplier shortlist %28New search%29.xlsx"'
      end
    end
  end
end