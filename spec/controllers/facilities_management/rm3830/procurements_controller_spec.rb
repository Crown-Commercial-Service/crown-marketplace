require 'rails_helper'

# rubocop:disable RSpec/AnyInstance
# rubocop:disable RSpec/NestedGroups
RSpec.describe FacilitiesManagement::RM3830::ProcurementsController do
  let(:default_params) { { service: 'facilities_management', framework: 'RM3830' } }
  let(:procurement) { create(:facilities_management_rm3830_procurement, contract_name: 'New search', user: subject.current_user) }

  context 'without buyer details' do
    login_fm_buyer

    it 'will redirect to buyer details' do
      get :show, params: { id: procurement.id }

      expect(response).to redirect_to edit_facilities_management_buyer_detail_path(id: controller.current_user.buyer_detail.id)
    end
  end

  context 'with buyer details' do
    login_fm_buyer_with_details

    describe 'GET index' do
      it 'renders the correct template' do
        get :index

        expect(response).to render_template('index')
      end
    end

    describe 'GET show' do
      context 'with a procurement in the quick search state' do
        it 'renders the show page' do
          get :show, params: { id: procurement.id }

          expect(response).to render_template('show')
        end

        context 'when the user deletes the quick search' do
          it 'renders the show page' do
            get :show, params: { id: procurement.id, delete: 'y' }

            expect(response).to render_template('show')
          end
        end

        context 'when the user continues from quick search' do
          before { get :show, params: { id: procurement.id, what_happens_next: true } }

          it 'renders the show page' do
            expect(response).to render_template('show')
          end

          it 'will have a view name of what_happens_next' do
            expect(assigns(:view_name)).to eq 'what_happens_next'
          end
        end
      end

      context 'with a procurement in the detailed search state' do
        before { procurement.update(aasm_state: 'detailed_search') }

        it 'renders the show template' do
          get :show, params: { id: procurement.id }

          expect(response).to render_template('show')
        end

        it 'sets the view name to requirements' do
          get :show, params: { id: procurement.id }

          expect(assigns(:view_name)).to eq 'requirements'
        end

        context 'and the procurement has buildings with missing regions' do
          let(:building) { create(:facilities_management_building, user: subject.current_user, address_region: nil, address_region_code: nil) }

          before { procurement.update(procurement_buildings_attributes: { '0': { building_id: building.id, active: true } }) }

          it 'redirects to missing_regions' do
            get :show, params: { id: procurement.id }

            expect(response).to redirect_to(facilities_management_rm3830_missing_regions_path(procurement_id: procurement.id))
          end
        end
      end

      context 'with a procurement which has just bulk uploaded successfully' do
        before do
          procurement.update(aasm_state: 'detailed_search_bulk_upload')
          procurement.create_spreadsheet_import(aasm_state: 'succeeded')
          get :show, params: { id: procurement.id } # First navigation after bulk upload success
        end

        it 'redirects to file upload status page on first navigation' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_spreadsheet_import_path(
            procurement, procurement.spreadsheet_import
          )
        end
      end

      context 'with a procurement which has had bulk uploaded' do
        before do
          procurement.update(aasm_state: 'detailed_search')
          procurement.create_spreadsheet_import(aasm_state: 'succeeded')
          get :show, params: { id: procurement.id } # First navigation after bulk upload success
        end

        it 'renders the show page wehn in in detailed search' do
          expect(response).to render_template(:show)
        end
      end

      context 'with a procurement in the choose contract value state' do
        before do
          procurement.update(aasm_state: 'choose_contract_value')
          allow_any_instance_of(procurement.class).to receive(:procurement_building_services_not_used_in_calculation).and_return([])
        end

        it 'renders the show template' do
          get :show, params: { id: procurement.id }

          expect(response).to render_template('show')
        end

        it 'sets the view name to choose_contract_value' do
          get :show, params: { id: procurement.id }

          expect(assigns(:view_name)).to eq 'choose_contract_value'
        end
      end

      context 'with a procurement in the results state' do
        before { procurement.update(aasm_state: 'results') }

        it 'renders the show template' do
          get :show, params: { id: procurement.id }

          expect(response).to render_template('show')
        end

        it 'sets the view name to choose_contract_value' do
          get :show, params: { id: procurement.id }

          expect(assigns(:view_name)).to eq 'results'
        end

        context 'when lot number is selected by customer' do
          before { procurement.update(lot_number_selected_by_customer: true) }

          it 'the secondary button is named change_the_contract_value' do
            get :show, params: { id: procurement.id }

            expect(assigns(:page_description).navigation_details.secondary_name).to eq 'change_the_contract_value'
          end
        end

        context 'when lot number is not selected by customer' do
          before { procurement.update(lot_number_selected_by_customer: false) }

          it 'the secondary button is named change_requirements' do
            get :show, params: { id: procurement.id }

            expect(assigns(:page_description).navigation_details.secondary_name).to eq 'change_requirements'
          end
        end
      end

      context 'when a procurement in the results state with competition state chosen' do
        render_views

        before do
          procurement.update(aasm_state: 'results')
          get :show, params: { id: procurement.id, fc_chosen: 'true' }
        end

        it 'renders the show template' do
          expect(response).to render_template('show')
        end

        it 'sets the view name to further_competition' do
          expect(assigns(:view_name)).to eq 'further_competition'
        end

        it 'displays Save as further competition button' do
          expect(response.body).to match(/Save as further competition/)
        end
      end

      context 'when the procurement is in a further competition state' do
        render_views

        before do
          procurement.update(aasm_state: 'further_competition')
          get :show, params: { id: procurement.id }
        end

        it 'renders the show template' do
          expect(response).to render_template('show')
        end

        it 'sets the view name to further_competition' do
          expect(assigns(:view_name)).to eq 'further_competition'
        end

        it 'displays Make a copy button' do
          expect(response.body).to match(/Make a copy/)
        end
      end

      context 'when the procurement is in a da_draft state' do
        before { procurement.update(aasm_state: 'da_draft') }

        it 'redirects to contract_details' do
          get :show, params: { id: procurement.id }

          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path(procurement_id: procurement.id)
        end
      end
    end

    describe 'GET new' do
      it 'renders the correct template' do
        get :new, params: { region_codes: ['UKC1'], service_codes: ['C.1'] }

        expect(response).to render_template('new')
      end
    end

    describe 'GET edit' do
      context 'when the step is not recognised' do
        it 'redirects to the show page' do
          get :edit, params: { id: procurement.id, step: 'services_and_buildings' }

          expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
        end
      end

      it 'renders the correct template' do
        get :edit, params: { id: procurement.id, step: 'services' }

        expect(response).to render_template('edit')
      end
    end

    describe 'GET what happens next' do
      context 'when on the dashboard' do
        it 'would render the what_happens_next' do
          get :what_happens_next

          expect(response).to render_template('what_happens_next')
        end
      end
    end

    describe 'POST create' do
      context 'with a valid record' do
        context 'when Save and continue is selected with no region codes' do
          it 'redirects to facilities_management_rm3830_procurement_path for the new record' do
            post :create, params: { facilities_management_rm3830_procurement: { contract_name: 'New procurement' } }
            new_procurement = FacilitiesManagement::RM3830::Procurement.all.order(created_at: :asc).first
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(new_procurement.id)
          end
        end

        context 'when Save and continue is selected with region codes' do
          it 'redirects to facilities_management_rm3830_procurement_path for the new record' do
            post :create, params: { facilities_management_rm3830_procurement: { contract_name: 'New procurement', region_codes: %w[UKC1 UKC2] } }
            new_procurement = FacilitiesManagement::RM3830::Procurement.all.order(created_at: :asc).first
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(new_procurement.id, what_happens_next: true)
          end
        end

        context 'when Save for later is selected' do
          it 'redirects to show path' do
            post :create, params: { save_for_later: 'Save for later', facilities_management_rm3830_procurement: { contract_name: 'New procurement', region_codes: %w[UKC1 UKC2] } }
            expect(response).to redirect_to facilities_management_rm3830_procurements_path
          end
        end
      end

      context 'with an invalid record' do
        it 'render the new template' do
          post :create, params: { facilities_management_rm3830_procurement: { invalid_param: 'invalid' } }

          expect(response).to render_template('new')
        end
      end
    end

    describe 'PATCH update' do
      context 'with a valid update' do
        before do
          procurement.update(aasm_state: 'detailed_search')
          patch :update, params: { id: procurement.id, step: 'name', facilities_management_rm3830_procurement: { contract_name: 'Updated name' } }
        end

        it 'redirects to the show page for the record' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement.id)
        end

        it 'correctly updates the provided params' do
          procurement.reload

          expect(procurement.contract_name).to eq('Updated name')
        end
      end

      context 'with an invalid update' do
        before do
          patch :update, params: { id: procurement.id, facilities_management_rm3830_procurement: { contract_name: (0...200).map { ('a'..'z').to_a[rand(26)] }.join, step: 'contract_name' } }
        end

        it 'render the edit page for the record' do
          expect(response).to render_template('edit')
        end

        it 'does not update the record' do
          procurement.reload

          expect(procurement.contract_name).to eq('New search')
        end
      end

      context 'when changing from detailed search to bulk upload' do
        before do
          procurement.update(aasm_state: 'detailed_search')
          patch :update, params: { id: procurement.id, bulk_upload_spreadsheet: 'true' }
        end

        it 'will change the state to detailed search - bulk upload on selection' do
          procurement.reload

          expect(procurement.aasm_state).to eq 'detailed_search_bulk_upload'
        end

        it 'will redirect to the spreadsheet import path' do
          expect(response).to redirect_to new_facilities_management_rm3830_procurement_spreadsheet_import_path(procurement_id: procurement.id)
        end
      end

      context 'when in bulk upload and saving for later' do
        before do
          procurement.update(aasm_state: 'detailed_search_bulk_upload')
          patch :update, params: { id: procurement.id, bulk_upload_spreadsheet: 'Save and return to procurements dashboard' }
        end

        it 'will remain in the bulk upload state' do
          expect(procurement.aasm_state).to eq 'detailed_search_bulk_upload'
        end

        it 'will redirect to the facilities_management_rm3830_procurements_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurements_path
        end
      end

      context 'when in bulk upload and going back to detailed search' do
        before do
          procurement.update(aasm_state: 'detailed_search_bulk_upload')
          patch :update, params: { id: procurement.id, change_requirements: 'Change requirements' }
        end

        it 'will remain in the bulk upload state' do
          procurement.reload
          expect(procurement.aasm_state).to eq 'detailed_search'
        end

        it 'will redirect to the facilities_management_rm3830_procurements_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
        end
      end

      context 'when change requirements is selected on the results page' do
        before do
          procurement.update(aasm_state: 'results')
          patch :update, params: { id: procurement.id, change_requirements: 'Change requirements' }
        end

        it 'redirects to facilities_management_rm3830_procurement_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
        end

        it 'changes the state to detailed search' do
          procurement.reload
          expect(procurement.aasm_state).to eq 'detailed_search'
        end
      end

      context 'when continuing to results' do
        let(:obj) { double }

        before do
          allow(FacilitiesManagement::RM3830::AssessedValueCalculator).to receive(:new).with(procurement.id).and_return(obj)
          allow_any_instance_of(procurement.class).to receive(:copy_fm_rate_cards_to_frozen)
          allow(obj).to receive_messages(assessed_value: 0.1234, lot_number: '1a', sorted_list: [])
          procurement.update(aasm_state: 'detailed_search')
        end

        context 'with a valid procurement' do
          before do
            allow_any_instance_of(procurement.class).to receive(:valid?).and_return(true)
            allow_any_instance_of(procurement.class).to receive(:valid?).with(:continue).and_return(true)
            patch :update, params: { id: procurement.id, continue_to_results: 'Continue to results' }
          end

          it 'redirects to facilities_management_rm3830_procurement_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
          end

          it 'changes the state to results' do
            procurement.reload
            expect(procurement.aasm_state).to eq 'results'
          end
        end

        context 'with an invalid procurement' do
          before do
            allow_any_instance_of(procurement.class).to receive(:valid?).and_return(false)
            allow_any_instance_of(procurement.class).to receive(:valid?).with(:continue).and_return(false)
            patch :update, params: { id: procurement.id, continue_to_results: 'Continue to results' }
          end

          it 'redirects to facilities_management_rm3830_procurement_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement, validate: true)
          end

          it 'the state does not change' do
            procurement.reload
            expect(procurement.aasm_state).to eq 'detailed_search'
          end
        end
      end

      context 'when change contract value is selected on the results page' do
        before do
          procurement.update(aasm_state: 'results')
          patch :update, params: { id: procurement.id, change_the_contract_value: 'Change contract value' }
        end

        it 'redirects to facilities_management_rm3830_procurement_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
        end

        it 'changes the state to detailed search' do
          procurement.reload
          expect(procurement.aasm_state).to eq 'choose_contract_value'
        end
      end

      context 'when continuing from choose contract value to the results page' do
        let(:obj) { double }

        before do
          procurement.update(aasm_state: 'choose_contract_value')
          procurement.update(assessed_value: 82486)
          allow_any_instance_of(procurement.class).to receive(:procurement_building_services_not_used_in_calculation).and_return([])
          allow(FacilitiesManagement::RM3830::AssessedValueCalculator).to receive(:new).with(procurement.id).and_return(obj)
          allow(obj).to receive(:sorted_list).and_return([])
        end

        context 'when the procurement is not valid' do
          before { patch :update, params: { id: procurement.id, continue_from_change_contract_value: 'Continue', facilities_management_rm3830_procurement: { lot_number: '', lot_number_selected_by_customer: true } } }

          it 'renders the show page again' do
            expect(response).to render_template('show')
          end

          it 'will not change the state' do
            procurement.reload
            expect(procurement.aasm_state).to eq 'choose_contract_value'
          end
        end

        context 'when the procurement is valid' do
          before { patch :update, params: { id: procurement.id, continue_from_change_contract_value: 'Continue', facilities_management_rm3830_procurement: { lot_number: '1a', lot_number_selected_by_customer: true } } }

          it 'renders the show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
          end

          it 'changes the state to results' do
            procurement.reload
            expect(procurement.aasm_state).to eq 'results'
          end
        end
      end

      context 'when setting the route to market on the results page' do
        before do
          procurement.update(aasm_state: 'results')
        end

        context 'when the selection is invalid' do
          before do
            patch :update, params: { id: procurement.id, continue_from_results: 'Continue', facilities_management_rm3830_procurement: { route_to_market: '' } }
          end

          it 'will render the results page' do
            expect(response).to render_template('show')
          end

          it 'will have a view name of results' do
            expect(assigns(:view_name)).to eq 'results'
          end

          it 'will not change the state' do
            procurement.reload
            expect(procurement.aasm_state).to eq('results')
          end
        end

        context 'when the selection is valid and direct award is chosen' do
          before do
            patch :update, params: { id: procurement.id, continue_from_results: 'Continue', facilities_management_rm3830_procurement: { route_to_market: 'da_draft' } }
          end

          it 'will redirect to facilities_management_rm3830_procurement_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement, fc_chosen: 'false')
          end

          it 'will change the state to da_draft' do
            procurement.reload
            expect(procurement.aasm_state).to eq('da_draft')
          end
        end

        context 'when the selection is valid and saving as further competition' do
          before do
            patch :update, params: { id: procurement.id, continue_from_results: 'Continue', facilities_management_rm3830_procurement: { route_to_market: 'further_competition' } }
          end

          it 'will redirect to facilities_management_rm3830_procurement_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement, fc_chosen: 'false')
          end

          it 'will change the state to further_competition' do
            procurement.reload
            expect(procurement.aasm_state).to eq('further_competition')
          end
        end

        context 'when the selection is valid and further competition is chosen' do
          before do
            patch :update, params: { id: procurement.id, continue_from_results: 'Continue', facilities_management_rm3830_procurement: { route_to_market: 'further_competition_chosen' } }
          end

          it 'will redirect to facilities_management_rm3830_procurement_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement, fc_chosen: 'true')
          end

          it 'will not change the state to further_competition' do
            procurement.reload
            expect(procurement.aasm_state).to eq('results')
          end
        end
      end

      context 'when the user is adding regions' do
        let(:region_codes) { ['UKE1', 'UKI3', 'UKL11'] }

        before do
          patch :update, params: { id: procurement.id, facilities_management_rm3830_procurement: { step: 'regions', region_codes: region_codes } }
        end

        it 'redirects to edit_facilities_management_rm3830_procurement_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
        end

        it 'updates the regions in the procurement' do
          procurement.reload
          expect(procurement.region_codes).to eq region_codes
        end
      end

      context 'when the user updates the service codes' do
        let(:service_codes) { ['C.1', 'O.1'] }
        let(:region_codes) { ['UKC1', 'UKN01'] }

        context 'when the user selects service codes' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_rm3830_procurement: { step: 'services', service_codes: service_codes } }
          end

          it 'redirects to edit_facilities_management_rm3830_procurement_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
          end

          it 'updates the service codes' do
            procurement.reload
            expect(procurement.service_codes).to eq service_codes
          end
        end

        context 'when the user does not select service codes' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_rm3830_procurement: { step: 'services' } }
          end

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'has the correct error message' do
            expect(assigns(:procurement).errors[:service_codes].first).to eq 'Select at least one service you need to include in your procurement'
          end
        end

        context 'when the user selects region codes' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_rm3830_procurement: { step: 'regions', region_codes: region_codes } }
          end

          it 'redirects to edit_facilities_management_rm3830_procurement_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
          end

          it 'updates the region codes' do
            procurement.reload
            expect(procurement.region_codes).to eq region_codes
          end
        end

        context 'when the user does not select region codes' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_rm3830_procurement: { step: 'regions' } }
          end

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'has the correct error message' do
            expect(assigns(:procurement).errors[:region_codes].first).to eq 'Select at least one region you need to include in your procurement'
          end
        end
      end

      context 'when the user exits bulk upload process' do
        before do
          procurement.update(aasm_state: state)
          patch :update, params: { id: procurement.id, exit_bulk_upload: 'Continue to procurement' }
          procurement.reload
        end

        context 'when the procurement is in detailed_search_bulk_upload' do
          let(:state) { 'detailed_search_bulk_upload' }

          it 'changes the state to detailed_search' do
            expect(procurement.detailed_search?).to be true
          end

          it 'redirects to the show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
          end
        end

        context 'when the procurement is not in detailed_search_bulk_upload' do
          let(:state) { 'quick_search' }

          it 'does not change the state' do
            expect(procurement.quick_search?).to be true
          end

          it 'redirects to the show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
          end
        end
      end
    end

    describe 'GET delete' do
      context 'when the user wants to delete the procurement' do
        before do
          get :delete, params: { procurement_id: procurement.id }
        end

        it 'renders the delete page' do
          expect(response).to render_template :delete
        end
      end

      context 'when the user tries to delete a procurement that cannot be deleted' do
        before do
          procurement.update(aasm_state: 'closed')
          get :delete, params: { procurement_id: procurement.id }
        end

        it 'redirects facilities_management_rm3830_procurements' do
          expect(response).to redirect_to facilities_management_rm3830_procurements_path
        end
      end
    end

    describe 'POST destroy' do
      context 'when the user deletes the procurement' do
        before do
          post :destroy, params: { id: procurement.id }
        end

        it 'deletes the procurement' do
          expect(procurement.class.where(id: procurement.id)).not_to exist
        end

        it 'redirects facilities_management_rm3830_procurements_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurements_path(deleted: procurement.contract_name)
        end
      end

      context 'when the user tries to delete a procurement that cannot be deleted' do
        before do
          procurement.update(aasm_state: 'closed')
          post :destroy, params: { id: procurement.id }
        end

        it 'redirects facilities_management_rm3830_procurements' do
          expect(response).to redirect_to facilities_management_rm3830_procurements_path
        end
      end
    end

    describe 'downloading the spreadsheets' do
      before do
        spreadsheet_double = double
        contract_double = double
        fake_id = double
        allow_any_instance_of(procurement.class).to receive(:first_unsent_contract).and_return(contract_double)
        allow(contract_double).to receive(:id).and_return(fake_id)
        allow(spreadsheet_creator).to receive(:new).with(fake_id).and_return(spreadsheet_double)
        allow(spreadsheet_double).to receive(:build)
        allow(spreadsheet_double).to receive(:to_xlsx)
        get spreadsheet_action, params: { procurement_id: procurement.id }
      end

      context 'when deliverables_matrix' do
        let(:spreadsheet_creator) { FacilitiesManagement::RM3830::DeliverableMatrixSpreadsheetCreator }
        let(:spreadsheet_action) { :deliverables_matrix }

        it 'downloads the document with the right filename' do
          expect(response.headers['Content-Disposition']).to include 'filename="Attachment 2 - Statement of Requirements - Deliverables Matrix %28DA%29.xlsx"'
        end
      end

      context 'when price_matrix' do
        let(:spreadsheet_creator) { FacilitiesManagement::RM3830::PriceMatrixSpreadsheet }
        let(:spreadsheet_action) { :price_matrix }

        it 'downloads the document with the right filename' do
          expect(response.headers['Content-Disposition']).to include 'filename="Attachment 3 - Price Matrix %28DA%29.xlsx"'
        end
      end
    end
  end

  context 'when logging in as a different fm buyer than the one that created the procurement' do
    login_fm_buyer_with_details

    it 'redirects to the not permitted page' do
      procurement.update(aasm_state: 'detailed_search', user_id: create(:user).id)
      patch :update, params: { id: procurement.id, step: 'name', facilities_management_rm3830_procurement: { contract_name: 'Updated name' } }
      expect(response).to redirect_to '/facilities-management/RM3830/not-permitted'
    end
  end

  describe 'GET quick_view_results_spreadsheet' do
    login_fm_buyer_with_details

    before do
      procurement.update(aasm_state:)
      get :quick_view_results_spreadsheet, params: { procurement_id: procurement.id }
    end

    context 'when the procurement is not in quick search' do
      let(:aasm_state) { 'detailed_search' }

      it 'redirects to the show page' do
        expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
      end
    end

    context 'when the procurement is in quick search' do
      let(:aasm_state) { 'quick_search' }

      it 'does download a spreadsheet' do
        expect(response.headers['Content-Disposition']).to include 'filename="Quick view results %28New search%29.xlsx"'
      end
    end
  end

  describe 'GET further_competition_spreadsheet' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_further_competition, contract_name: 'New search', user: subject.current_user, aasm_state: aasm_state) }

    login_fm_buyer_with_details

    before { get :further_competition_spreadsheet, params: { procurement_id: procurement.id } }

    context 'when the procurement is not in further competition' do
      let(:aasm_state) { 'direct_award' }

      it 'redirects to the show page' do
        expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
      end
    end

    context 'when the procurement is in further competition' do
      let(:aasm_state) { 'further_competition' }

      it 'does download a spreadsheet' do
        expect(response.headers['Content-Disposition']).to include 'filename="further_competition_procurement_summary.xlsx"'
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
# rubocop:enable RSpec/AnyInstance
