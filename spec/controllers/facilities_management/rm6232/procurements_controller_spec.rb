require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::ProcurementsController do
  let(:default_params) { { service: 'facilities_management', framework: 'RM6232' } }
  let(:user) { controller.current_user }

  login_fm_buyer_with_details

  context 'without buyer details' do
    login_fm_buyer

    it 'will redirect to buyer details' do
      get :new

      expect(response).to redirect_to edit_facilities_management_buyer_detail_path(id: user.buyer_detail.id)
    end
  end

  describe 'GET index' do
    before do
      create_list(:facilities_management_rm6232_procurement_what_happens_next, 5, aasm_state: 'what_happens_next', user: user)
      get :index
    end

    it 'renders the correct template' do
      expect(response).to render_template('index')
    end

    it 'groups up the procurements' do
      expect(assigns(:searches).length).to eq 5
    end

    it 'sets the back path' do
      expect(assigns(:back_path)).to eq facilities_management_rm6232_path
      expect(assigns(:back_text)).to eq 'Return to your account'
    end
  end

  describe 'GET show' do
    before { get :show, params: { id: procurement.id } }

    render_views

    context 'when the user did create the procurement' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_what_happens_next, user: user) }

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end

      it 'sets the back path' do
        expect(assigns(:back_path)).to eq facilities_management_rm6232_procurements_path
        expect(assigns(:back_text)).to eq 'Return to saved searches'
      end
    end

    context 'when the user did not create the procurement' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_what_happens_next, user: create(:user)) }

      before { get :show, params: { id: procurement.id } }

      it 'redirects to the not permitted path' do
        expect(response).to redirect_to facilities_management_rm6232_not_permitted_path
      end
    end

    # This has been cut but it may return on the future
    # context 'and the procurement state is what_happens_next' do
    #   let(:procurement) { create(:facilities_management_rm6232_procurement_what_happens_next, user: user) }

    #   it 'renders the what happens next partial' do
    #     expect(response).to render_template(partial: '_what_happens_next')
    #   end

    #   it 'sets the procurement' do
    #     expect(assigns(:procurement)).to eq procurement
    #   end

    #   it 'sets the back path' do
    #     expect(assigns(:back_path)).to eq facilities_management_rm6232_procurements_path
    #     expect(assigns(:back_text)).to eq 'Return to procurements dashboard'
    #   end
    # end

    # context 'and the procurement state is entering_requirements' do
    #   let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, user: user) }

    #   it 'renders the entering requirements partial' do
    #     expect(response).to render_template(partial: '_entering_requirements')
    #   end

    #   it 'sets the procurement' do
    #     expect(assigns(:procurement)).to eq procurement
    #   end

    #   it 'sets the back path' do
    #     expect(assigns(:back_path)).to eq facilities_management_rm6232_procurements_path
    #     expect(assigns(:back_text)).to eq 'Return to procurements dashboard'
    #   end

    #   context 'and the procurement has buildings with missing regions' do
    #     let(:building) { create(:facilities_management_building, user: user, address_region: nil, address_region_code: nil) }
    #     let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, user: user, procurement_buildings_attributes: { '0': { building_id: building.id, active: true } }) }

    #     it 'redirects to missing_regions' do
    #       expect(response).to redirect_to(facilities_management_rm6232_missing_regions_path(procurement_id: procurement.id))
    #     end
    #   end
    # end

    # context 'and the procurement state is results' do
    #   let(:procurement) { create(:facilities_management_rm6232_procurement_results, user: user) }

    #   it 'renders the results partial' do
    #     expect(response).to render_template(partial: '_results')
    #   end

    #   it 'sets the procurement' do
    #     expect(assigns(:procurement)).to eq procurement
    #   end

    #   it 'sets the back path' do
    #     expect(assigns(:back_path)).to eq facilities_management_rm6232_procurements_path
    #     expect(assigns(:back_text)).to eq 'Return to procurements dashboard'
    #   end
    # end

    # context 'and the procurement state is further_information' do
    #   let(:procurement) { create(:facilities_management_rm6232_procurement_further_information, user: user) }

    #   it 'renders the further_information partial' do
    #     expect(response).to render_template(partial: '_further_information')
    #   end

    #   it 'sets the procurement' do
    #     expect(assigns(:procurement)).to eq procurement
    #   end

    #   it 'sets the back path' do
    #     expect(assigns(:back_path)).to eq facilities_management_rm6232_procurements_path
    #     expect(assigns(:back_text)).to eq 'Return to procurements dashboard'
    #   end
    # end
  end

  describe 'GET new' do
    before { get :new, params: { annual_contract_value: 123_456, region_codes: ['UKC1'], service_codes: ['E.1'] } }

    it 'renders the correct template' do
      expect(response).to render_template('new')
    end

    it 'sets the back path and text correctly' do
      expect(assigns(:back_path)).to eq '/facilities-management/RM6232/annual-contract-value?annual_contract_value=123456&region_codes%5B%5D=UKC1&service_codes%5B%5D=E.1'
      expect(assigns(:back_text)).to eq 'Return to annual contract cost'
    end

    it 'sets the suppliers' do
      expect(assigns(:suppliers).class.to_s).to eq 'FacilitiesManagement::RM6232::Supplier::ActiveRecord_Relation'
    end

    it 'sets the procurement with the correct details' do
      expect(
        assigns(:procurement).attributes.slice('user_id', 'service_codes', 'region_codes', 'annual_contract_value', 'lot_number')
      ).to eq(
        { 'user_id' => user.id,
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
        expect(assigns(:back_text)).to eq 'Return to annual contract cost'
      end

      it 'sets the suppliers' do
        expect(assigns(:suppliers).class.to_s).to eq 'FacilitiesManagement::RM6232::Supplier::ActiveRecord_Relation'
      end

      it 'sets the procurement with the correct details' do
        expect(
          assigns(:procurement).attributes.slice('user_id', 'service_codes', 'region_codes', 'annual_contract_value', 'lot_number')
        ).to eq(
          { 'user_id' => user.id,
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

  # This has been cut but it may return on the future
  # describe 'PUT update_show' do
  #   context 'and the procurement state is entering_requirements' do
  #     let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, user: user) }

  #     before do
  #
  #       allow_any_instance_of(procurement.class).to receive(:valid?).and_return(safe_to_continue)
  #       allow_any_instance_of(procurement.class).to receive(:valid?).with(:entering_requirements).and_return(safe_to_continue)
  #         #       put :update_show, params: { procurement_id: procurement.id }
  #     end

  #     context 'when it is safe to continue' do
  #       let(:safe_to_continue) { true }

  #       it 'sets the procurement' do
  #         expect(assigns(:procurement)).to eq procurement
  #       end

  #       it 'redirects to the show page' do
  #         expect(response).to redirect_to facilities_management_rm6232_procurement_path(procurement.id)
  #       end

  #       it 'updates the procurement state' do
  #         procurement.reload

  #         expect(procurement.results?).to be true
  #       end
  #     end

  #     context 'when it is not safe to continue' do
  #       let(:safe_to_continue) { false }

  #       render_views

  #       it 'sets the procurement' do
  #         expect(assigns(:procurement)).to eq procurement
  #       end

  #       it 'renders the entering requirements next partial' do
  #         expect(response).to render_template(partial: '_entering_requirements')
  #       end

  #       it 'sets the back path' do
  #         expect(assigns(:back_path)).to eq facilities_management_rm6232_procurements_path
  #         expect(assigns(:back_text)).to eq 'Return to procurements dashboard'
  #       end
  #     end
  #   end

  #   context 'and the procurement state is results' do
  #     let(:procurement) { create(:facilities_management_rm6232_procurement_results, user: user) }

  #     before { put :update_show, params: { procurement_id: procurement.id, **button_params } }

  #     context 'when the use clicks save and continue' do
  #       let(:button_params) { { 'commit': 'Save and continue' } }

  #       it 'sets the procurement' do
  #         expect(assigns(:procurement)).to eq procurement
  #       end

  #       it 'redirects to the show page' do
  #         expect(response).to redirect_to facilities_management_rm6232_procurement_path(procurement.id)
  #       end

  #       it 'updates the procurement state to further information' do
  #         procurement.reload

  #         expect(procurement.further_information?).to be true
  #       end
  #     end

  #     context 'when the user clicks change requirements' do
  #       let(:button_params) { { 'change_requirements': 'Change requirements' } }

  #       it 'sets the procurement' do
  #         expect(assigns(:procurement)).to eq procurement
  #       end

  #       it 'redirects to the show page' do
  #         expect(response).to redirect_to facilities_management_rm6232_procurement_path(procurement.id)
  #       end

  #       it 'updates the procurement state to entering requirements' do
  #         procurement.reload

  #         expect(procurement.entering_requirements?).to be true
  #       end
  #     end
  #   end
  # end

  # describe 'GET supplier_shortlist_spreadsheet' do
  #   login_fm_buyer_with_details

  #   let(:state) { 'what_happens_next' }
  #   let(:procurement) { create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: state, user: user, contract_name: 'New search') }

  #   before { get :supplier_shortlist_spreadsheet, params: { procurement_id: procurement.id } }

  #   context 'when the procurement is not in what happens next' do
  #     let(:state) { 'entering_requirements' }

  #     it 'redirects to the show page' do
  #       expect(response).to redirect_to facilities_management_rm6232_procurement_path(id: procurement.id)
  #     end
  #   end

  #   context 'when the procurement is in what happens next' do
  #     let(:state) { 'what_happens_next' }

  #     it 'does download a spreadsheet' do
  #       expect(response.headers['Content-Disposition']).to include 'filename="Supplier shortlist %28New search%29.xlsx"'
  #     end
  #   end
  # end

  describe 'GET supplier_shortlist_spreadsheet' do
    login_fm_buyer_with_details

    let(:procurement) { create(:facilities_management_rm6232_procurement_what_happens_next, user: user, contract_name: 'New search') }

    before { get :supplier_shortlist_spreadsheet, params: { procurement_id: procurement.id } }

    it 'download a spreadsheet' do
      expect(response.headers['Content-Disposition']).to include 'filename="Supplier shortlist %28New search%29.xlsx"'
    end
  end
end
