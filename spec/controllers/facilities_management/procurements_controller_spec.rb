require 'rails_helper'

# rubocop:disable RSpec/AnyInstance
# rubocop:disable RSpec/NestedGroups
RSpec.describe FacilitiesManagement::ProcurementsController, type: :controller do
  let(:procurement) { create(:facilities_management_procurement, contract_name: 'New search', user: subject.current_user) }

  context 'without buyer details' do
    login_fm_buyer

    it 'will redirect to buyer details' do
      get :show, params: { id: procurement.id }

      expect(response.status).to eq(302)
      expect(response.headers.any? { |h, v| h == 'Location' && v.include?('buyer_details') }).to eq(true)
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
          before { get :show, params: { id: procurement.id, 'what_happens_next': true } }

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

        it 'sets the view name to detailed_search_summary' do
          get :show, params: { id: procurement.id }

          expect(assigns(:view_name)).to eq 'detailed_search_summary'
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

        it 'renders the show template' do
          get :show, params: { id: procurement.id }

          expect(response).to render_template('show')
        end

        context 'when da_journey_state is pricing' do
          before { procurement.update(da_journey_state: 'pricing') }

          it 'sets the view da to pricing' do
            get :show, params: { id: procurement.id }

            expect(assigns(:view_da)).to eq 'pricing'
          end
        end

        context 'when da_journey_state is what_next' do
          before { procurement.update(da_journey_state: 'what_next') }

          it 'sets the view da to pricing' do
            get :show, params: { id: procurement.id }

            expect(assigns(:view_da)).to eq 'what_next'
          end
        end

        context 'when da_journey_state is important_information' do
          before { procurement.update(da_journey_state: 'important_information') }

          it 'sets the view da to did_you_know' do
            get :show, params: { id: procurement.id }

            expect(assigns(:view_da)).to eq 'did_you_know'
          end
        end

        context 'when da_journey_state is contract_details' do
          before { procurement.update(da_journey_state: 'contract_details') }

          it 'sets the view da to contract_details' do
            get :show, params: { id: procurement.id }

            expect(assigns(:view_da)).to eq 'contract_details'
          end
        end

        context 'when da_journey_state is review_and_generate' do
          before { procurement.update(da_journey_state: 'review_and_generate') }

          it 'sets the view da to review_and_generate_documents' do
            get :show, params: { id: procurement.id }

            expect(assigns(:view_da)).to eq 'review_and_generate_documents'
          end
        end

        context 'when da_journey_state is review' do
          before { procurement.update(da_journey_state: 'review') }

          it 'sets the view da to review_contract' do
            get :show, params: { id: procurement.id }

            expect(assigns(:view_da)).to eq 'review_contract'
          end
        end

        context 'when da_journey_state is sending' do
          before { procurement.update(da_journey_state: 'sending') }

          it 'sets the view da to sending_the_contract' do
            get :show, params: { id: procurement.id }

            expect(assigns(:view_da)).to eq 'sending_the_contract'
          end
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
      it 'renders the correct template' do
        get :edit, params: { id: procurement.id, step: 'tupe' }

        expect(response).to render_template('edit')
      end

      context 'when the procurement is in detailed search' do
        before do
          procurement.update(aasm_state: 'detailed_search')
        end

        context 'when on the TUPE step' do
          before do
            get :edit, params: { id: procurement.id, step: 'tupe' }
          end

          it 'will have facilities_management_procurement_path as the back_link' do
            expect(assigns(:back_link)).to eq facilities_management_procurement_path(id: procurement.id)
          end

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'will have a view name of detailed_search_summary' do
            expect(assigns(:view_name)).to eq 'detailed_search_summary'
          end

          it 'will set the view_da to nil' do
            expect(assigns(:view_da)).to be nil
          end
        end

        context 'when the step is procurement_buildings' do
          before do
            create :facilities_management_building, user: controller.current_user
            get :edit, params: { id: procurement.id, step: 'procurement_buildings' }
          end

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'sets the buildings_data variable' do
            expect(assigns(:buildings_data).length).to eq 1
          end
        end
      end

      context 'when the procurement is in da_draft' do
        before do
          procurement.update(aasm_state: 'da_draft')
        end

        context 'when updating payment method' do
          before do
            get :edit, params: { id: procurement.id, step: 'payment_method' }
          end

          it 'will redirect to facilities_management_procurement_url' do
            expect(response).to render_template('edit')
          end

          it 'will have a view name of edit' do
            expect(assigns(:view_name)).to eq 'edit'
          end

          it 'will have a view_da of payment_method' do
            expect(assigns(:view_da)).to eq 'payment_method'
          end
        end
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
        context 'when Save and continue is selected' do
          it 'redirects to edit path for the new record' do
            post :create, params: { facilities_management_procurement: { contract_name: 'New procurement' } }
            new_procurement = FacilitiesManagement::Procurement.all.order(created_at: :asc).first
            expect(response).to redirect_to facilities_management_procurement_path(new_procurement.id, 'what_happens_next': true)
          end
        end

        context 'when Save for later is selected' do
          it 'redirects to show path' do
            post :create, params: { save_for_later: 'Save for later', facilities_management_procurement: { contract_name: 'New procurement' } }
            expect(response).to redirect_to facilities_management_procurements_path
          end
        end
      end

      context 'with an invalid record' do
        it 'render the new template' do
          post :create, params: { facilities_management_procurement: { invalid_param: 'invalid' } }

          expect(response).to render_template('new')
        end
      end
    end

    describe 'PATCH update' do
      context 'with a valid update' do
        before do
          procurement.update(aasm_state: 'detailed_search')
          patch :update, params: { id: procurement.id, step: 'name', facilities_management_procurement: { contract_name: 'Updated name' } }
        end

        it 'redirects to the show page for the record' do
          expect(response).to redirect_to facilities_management_procurement_path(procurement.id)
        end

        it 'correctly updates the provided params' do
          procurement.reload

          expect(procurement.contract_name).to eq('Updated name')
        end
      end

      context 'with an invalid update' do
        before do
          patch :update, params: { id: procurement.id, facilities_management_procurement: { contract_name: (0...200).map { ('a'..'z').to_a[rand(26)] }.join, step: 'contract_name' } }
        end

        it 'render the edit page for the record' do
          expect(response).to render_template('edit')
        end

        it 'does not update the record' do
          procurement.reload

          expect(procurement.contract_name).to eq('New search')
        end
      end

      context 'when change requirements is selected on the results page' do
        before do
          procurement.update(aasm_state: 'results')
          patch :update, params: { id: procurement.id, change_requirements: 'Change requirements' }
        end

        it 'redirects to facilities_management_procurement_path' do
          expect(response).to redirect_to facilities_management_procurement_path(procurement)
        end

        it 'changes the state to detailed search' do
          procurement.reload
          expect(procurement.aasm_state).to eq 'detailed_search'
        end
      end

      context 'when continuing to results' do
        let(:obj) { double }

        before do
          allow(FacilitiesManagement::AssessedValueCalculator).to receive(:new).with(procurement.id).and_return(obj)
          allow_any_instance_of(procurement.class).to receive(:copy_fm_rate_cards_to_frozen)
          allow(obj).to receive(:assessed_value).and_return(0.1234)
          allow(obj).to receive(:lot_number).and_return('1a')
          allow(obj).to receive(:sorted_list).and_return([])
          procurement.update(aasm_state: 'detailed_search')
        end

        context 'with a valid procurement' do
          before do
            allow_any_instance_of(procurement.class).to receive(:valid_on_continue?).and_return(true)
            patch :update, params: { id: procurement.id, continue_to_results: 'Continue to results' }
          end

          it 'redirects to facilities_management_procurement_path' do
            expect(response).to redirect_to facilities_management_procurement_path(procurement)
          end

          it 'changes the state to results' do
            procurement.reload
            expect(procurement.aasm_state).to eq 'results'
          end
        end

        context 'with an invalid procurement' do
          before do
            allow_any_instance_of(procurement.class).to receive(:valid_on_continue?).and_return(false)
            patch :update, params: { id: procurement.id, continue_to_results: 'Continue to results' }
          end

          it 'redirects to facilities_management_procurement_path' do
            expect(response).to redirect_to facilities_management_procurement_path(procurement, validate: true)
          end

          it 'the state does not change' do
            procurement.reload
            expect(procurement.aasm_state).to eq 'detailed_search'
          end
        end
      end

      context 'when change contract value is selected on the results page ' do
        before do
          procurement.update(aasm_state: 'results')
          patch :update, params: { id: procurement.id, change_the_contract_value: 'Change contract value' }
        end

        it 'redirects to facilities_management_procurement_path' do
          expect(response).to redirect_to facilities_management_procurement_path(procurement)
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
          allow(FacilitiesManagement::AssessedValueCalculator).to receive(:new).with(procurement.id).and_return(obj)
          allow(obj).to receive(:sorted_list).and_return([])
        end

        context 'when the procurement is not valid' do
          before { patch :update, params: { id: procurement.id, continue_from_change_contract_value: 'Continue', facilities_management_procurement: { lot_number: '', lot_number_selected_by_customer: true } } }

          it 'renders the show page again' do
            expect(response).to render_template('show')
          end

          it 'will not change the state' do
            procurement.reload
            expect(procurement.aasm_state).to eq 'choose_contract_value'
          end
        end

        context 'when the procurement is valid' do
          before { patch :update, params: { id: procurement.id, continue_from_change_contract_value: 'Continue', facilities_management_procurement: { lot_number: '1a', lot_number_selected_by_customer: true } } }

          it 'renders the show page' do
            expect(response).to redirect_to facilities_management_procurement_path(procurement)
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
            patch :update, params: { id: procurement.id, set_route_to_market: 'Continue', facilities_management_procurement: { route_to_market: '' } }
          end

          it 'will render the results page' do
            expect(response).to render_template('results')
          end

          it 'will not change the state' do
            procurement.reload
            expect(procurement.aasm_state).to eq('results')
          end
        end

        context 'when the selection is valid and direct award is chosen' do
          before do
            patch :update, params: { id: procurement.id, set_route_to_market: 'Continue', facilities_management_procurement: { route_to_market: 'da_draft' } }
          end

          it 'will redirect to facilities_management_procurement_path' do
            expect(response).to redirect_to facilities_management_procurement_path(procurement, fc_chosen: 'false')
          end

          it 'will change the state to da_draft' do
            procurement.reload
            expect(procurement.aasm_state).to eq('da_draft')
          end
        end

        context 'when the selection is valid and saving as further competition' do
          before do
            patch :update, params: { id: procurement.id, set_route_to_market: 'Continue', facilities_management_procurement: { route_to_market: 'further_competition' } }
          end

          it 'will redirect to facilities_management_procurement_path' do
            expect(response).to redirect_to facilities_management_procurement_path(procurement, fc_chosen: 'false')
          end

          it 'will change the state to further_competition' do
            procurement.reload
            expect(procurement.aasm_state).to eq('further_competition')
          end
        end

        context 'when the selection is valid and further competition is chosen' do
          before do
            patch :update, params: { id: procurement.id, set_route_to_market: 'Continue', facilities_management_procurement: { route_to_market: 'further_competition_chosen' } }
          end

          it 'will redirect to facilities_management_procurement_path' do
            expect(response).to redirect_to facilities_management_procurement_path(procurement, fc_chosen: 'true')
          end

          it 'will not change the state to further_competition' do
            procurement.reload
            expect(procurement.aasm_state).to eq('results')
          end
        end
      end

      context 'when continuing on the da journey' do
        before do
          procurement.update(aasm_state: 'da_draft')
          procurement.update(da_journey_state: 'pricing')
        end

        context 'when the procurement is valid' do
          before do
            allow_any_instance_of(procurement.class).to receive(:valid_on_continue?).and_return(true)
            patch :update, params: { id: procurement.id, continue_da: 'Save and continue' }
          end

          it 'redirects to facilities_management_procurement_path' do
            expect(response).to redirect_to facilities_management_procurement_path(procurement)
          end

          it 'changes da_journey_state to what_next' do
            procurement.reload
            expect(procurement.da_journey_state).to eq('what_next')
          end
        end

        context 'when the da_journey_state is sending' do
          let(:id) { 'eb7b05da-e52e-46a3-99ae-2cb0e6226232' }
          let(:obj) { double }

          before do
            procurement.update(da_journey_state: 'sending')
            allow_any_instance_of(procurement.class).to receive(:procurement_suppliers).and_return([obj])
            allow(obj).to receive(:id).and_return(id)
            allow_any_instance_of(procurement.class).to receive(:valid_on_continue?).and_return(true)
            allow_any_instance_of(procurement.class).to receive(:offer_to_next_supplier)
            patch :update, params: { id: procurement.id, continue_da: 'Save and continue' }
          end

          it 'redirects to facilities_management_procurement_path' do
            expect(response).to redirect_to facilities_management_procurement_contract_sent_index_path(procurement.id, contract_id: id)
          end

          it 'does not change the da_journey_state' do
            procurement.reload
            expect(procurement.da_journey_state).to eq('sent')
          end

          it 'changes the aasm_state to direct_award' do
            procurement.reload
            expect(procurement.aasm_state).to eq('direct_award')
          end
        end

        context 'when the procurement is not valid' do
          before do
            allow_any_instance_of(procurement.class).to receive(:valid_on_continue?).and_return(false)
            patch :update, params: { id: procurement.id, continue_da: 'Save and continue' }
          end

          it 'redirects to facilities_management_procurement_path' do
            expect(response).to redirect_to facilities_management_procurement_path(procurement, validate: true)
          end

          it 'does not change the da_journey_state' do
            procurement.reload
            expect(procurement.da_journey_state).to eq('pricing')
          end
        end
      end

      context 'when change contract details is selected' do
        before do
          procurement.update(aasm_state: 'da_draft')
          procurement.update(da_journey_state: 'review_and_generate')
          patch :update, params: { id: procurement.id, change_contract_details: 'Change contract details' }
        end

        it 'redirects to facilities_management_procurement_path' do
          expect(response).to redirect_to facilities_management_procurement_path(procurement)
        end

        it 'changes the da_journey_state to contact_details' do
          procurement.reload
          expect(procurement.da_journey_state).to eq('contract_details')
        end
      end

      context 'when continuing to review and generate' do
        before do
          procurement.update(aasm_state: 'da_draft')
          procurement.update(da_journey_state: 'contract_details')
        end

        context 'when the procurement is valid' do
          before do
            allow_any_instance_of(procurement.class).to receive(:valid?).with(:contract_details).and_return(true)
            allow_any_instance_of(procurement.class).to receive(:valid?).and_return(true)
            patch :update, params: { id: procurement.id, continue_to_review_and_generate: 'Continue to review and generate' }
          end

          it 'redirects to facilities_management_procurement_path' do
            expect(response).to redirect_to facilities_management_procurement_path(procurement)
          end

          it 'changes the da_journey_state to review_and_generate' do
            procurement.reload
            expect(procurement.da_journey_state).to eq('review_and_generate')
          end
        end

        context 'when the procurement is invalid' do
          before do
            allow_any_instance_of(procurement.class).to receive(:valid?).with(:contract_details).and_return(false)
            patch :update, params: { id: procurement.id, continue_to_review_and_generate: 'Continue to review and generate' }
          end

          it 'renders show when invalid' do
            expect(response).to render_template('show')
          end

          it 'does not change the da_journey_state when invalid' do
            expect(procurement.da_journey_state).to eq('contract_details')
          end
        end
      end

      context 'when return to review is selected' do
        before do
          procurement.update(aasm_state: 'da_draft')
          procurement.update(da_journey_state: 'sending')
          patch :update, params: { id: procurement.id, return_to_review_contract: 'Cancel, return to review your contract' }
        end

        it 'redirects to facilities_management_procurement_path' do
          expect(response).to redirect_to facilities_management_procurement_path(procurement)
        end

        it 'changes the da_journey_state to contact_details' do
          procurement.reload
          expect(procurement.da_journey_state).to eq('review')
        end
      end

      context 'when continuing to new invoicing contact details' do
        before do
          procurement.update(aasm_state: 'da_draft')
        end

        context 'when not using existing invoicing contact details' do
          before do
            procurement.update(da_journey_state: 'contract_details')
          end

          it 'will redirect to facilities_management_procurement_path if the invoice_contact_detail is not blank' do
            procurement.invoice_contact_detail = create(:facilities_management_procurement_invoice_contact_detail, procurement: procurement)
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'invoicing_contact_details', using_buyer_detail_for_invoice_details: false } }

            expect(response).to redirect_to facilities_management_procurement_path(procurement)
          end

          it 'will redirect to edit_facilities_management_procurement_path if the invoicing contact details are blank' do
            procurement.invoice_contact_detail = nil
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'invoicing_contact_details', using_buyer_detail_for_invoice_details: false } }

            expect(response).to redirect_to edit_facilities_management_procurement_path(id: procurement.id, step: 'new_invoicing_contact_details')
          end
        end

        context 'when using existing invoicing contact details' do
          before do
            procurement.update(da_journey_state: 'contract_details')
            allow(controller).to receive(:continue_to_new_invoice)
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'invoicing_contact_details', using_buyer_detail_for_invoice_details: true } }
          end

          it 'will not call continue_to_new_invoice method' do
            expect(controller).not_to have_received(:continue_to_new_invoice)
          end

          it 'will update the procurement' do
            expect(response).to redirect_to facilities_management_procurement_path(procurement)
          end
        end

        context 'when no option is selected' do
          before do
            procurement.update(da_journey_state: 'contract_details')
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'invoicing_contact_details', using_buyer_detail_for_invoice_details: nil } }
          end

          it 'will render the edit page' do
            expect(response).to render_template('edit')
          end

          it 'will have a inclusion error on the procurement' do
            expect(assigns(:procurement).errors[:using_buyer_detail_for_invoice_details].any?).to be true
          end
        end
      end

      context 'when continuing to new authorised contact details' do
        before do
          procurement.update(aasm_state: 'da_draft')
        end

        context 'when not using existing authorised contact details' do
          before do
            procurement.update(da_journey_state: 'contract_details')
          end

          it 'will redirect to facilities_management_procurement_path if the authorised contact details are not blank' do
            procurement.authorised_contact_detail = create(:facilities_management_procurement_authorised_contact_detail, procurement: procurement)
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'authorised_representative', using_buyer_detail_for_authorised_detail: false } }

            expect(response).to redirect_to facilities_management_procurement_path(procurement)
          end

          it 'will redirect to edit_facilities_management_procurement_path if the authorised contact details are blank' do
            procurement.authorised_contact_detail = nil
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'authorised_representative', using_buyer_detail_for_authorised_detail: false } }

            expect(response).to redirect_to edit_facilities_management_procurement_path(id: procurement.id, step: 'new_authorised_representative_details')
          end
        end

        context 'when using existing authorised contact details' do
          before do
            procurement.update(da_journey_state: 'contract_details')
            allow(controller).to receive(:continue_to_new_authorised)
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'authorised_representative', using_buyer_detail_for_authorised_detail: true } }
          end

          it 'will not call continue_to_new_authorised method' do
            expect(controller).not_to have_received(:continue_to_new_authorised)
          end

          it 'will update the procurement' do
            expect(response).to redirect_to facilities_management_procurement_path(procurement)
          end
        end

        context 'when no option is selected' do
          before do
            procurement.update(da_journey_state: 'contract_details')
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'authorised_representative', using_buyer_detail_for_authorised_detail: nil } }
          end

          it 'will render the edit page' do
            expect(response).to render_template('edit')
          end

          it 'will have a inclusion error on the procurement' do
            expect(assigns(:procurement).errors[:using_buyer_detail_for_authorised_detail].any?).to be true
          end
        end
      end

      context 'when continuing to new notices contact details' do
        before do
          procurement.update(aasm_state: 'da_draft')
        end

        context 'when not using existing notices contact details' do
          before do
            procurement.update(da_journey_state: 'contract_details')
          end

          it 'will redirect to facilities_management_procurement_path if the notices_contact_detail is not blank' do
            procurement.notices_contact_detail = create(:facilities_management_procurement_notices_contact_detail, procurement: procurement)
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'notices_contact_details', using_buyer_detail_for_notices_detail: false } }

            expect(response).to redirect_to facilities_management_procurement_path(procurement)
          end

          it 'will redirect to edit_facilities_management_procurement_path if the notices contact details are blank' do
            procurement.notices_contact_detail = nil
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'notices_contact_details', using_buyer_detail_for_notices_detail: false } }

            expect(response).to redirect_to edit_facilities_management_procurement_path(id: procurement.id, step: 'new_notices_contact_details')
          end
        end

        context 'when using existing notices contact details' do
          before do
            procurement.update(da_journey_state: 'contract_details')
            allow(controller).to receive(:continue_to_new_notices)
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'notices_contact_details', using_buyer_detail_for_notices_detail: true } }
          end

          it 'will not call continue_to_new_notices method' do
            expect(controller).not_to have_received(:continue_to_new_notices)
          end

          it 'will update the procurement' do
            expect(response).to redirect_to facilities_management_procurement_path(procurement)
          end
        end

        context 'when no option is selected' do
          before do
            procurement.update(da_journey_state: 'contract_details')
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'notices_contact_details', using_buyer_detail_for_notices_detail: nil } }
          end

          it 'will render the edit page' do
            expect(response).to render_template('edit')
          end

          it 'will have a inclusion error on the procurement' do
            expect(assigns(:procurement).errors[:using_buyer_detail_for_notices_detail].any?).to be true
          end
        end
      end

      context 'when on the pension funds page' do
        before do
          procurement.update(aasm_state: 'da_draft')
          procurement.update(da_journey_state: 'contract_details')
        end

        context 'when nothing is selected' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'local_government_pension_scheme', local_government_pension_scheme: nil } }
          end

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'has a step of local_government_pension_scheme view' do
            expect(controller.params[:step]).to eq 'local_government_pension_scheme'
          end
        end

        context 'when yes is selected' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'local_government_pension_scheme', local_government_pension_scheme: true } }
          end

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'has a step of local_government_pension_scheme view' do
            expect(controller.params[:step]).to eq 'pension_funds'
          end
        end

        context 'when no is selected' do
          it 'renders the edit page' do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'local_government_pension_scheme', local_government_pension_scheme: false } }
            expect(response).to redirect_to facilities_management_procurement_path(procurement)
          end
        end
      end

      def contact_details_address_hash(id, contact_detail)
        { id: id, organisation_address_line_1: contact_detail.organisation_address_line_1, organisation_address_town: contact_detail.organisation_address_town, organisation_address_postcode: contact_detail.organisation_address_postcode }
      end

      context 'when continuing to new invoicing contact details from the add address page' do
        let(:empty_invoice_contact_detail) { create(:facilities_management_procurement_invoice_contact_detail_empty, procurement: procurement) }
        let(:invoice_contact_detail) { create(:facilities_management_procurement_invoice_contact_detail) }

        before do
          procurement.update(da_journey_state: 'contract_details')
          procurement.update(invoice_contact_detail: empty_invoice_contact_detail)
        end

        context 'when a valid address is entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'new_invoicing_address', invoice_contact_detail_attributes: contact_details_address_hash(empty_invoice_contact_detail.id, invoice_contact_detail) } }
          end

          it 'redirects to edit_facilities_management_procurement_path' do
            expect(response).to redirect_to edit_facilities_management_procurement_path(id: procurement.id, step: 'new_invoicing_contact_details')
          end

          it 'updates the procurement to have an address' do
            procurement.reload
            expect(procurement.invoice_contact_detail.full_organisation_address).to eq invoice_contact_detail.full_organisation_address
          end
        end

        context 'when an invalid address is entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'new_invoicing_address', invoice_contact_detail_attributes: { id: empty_invoice_contact_detail.id } } }
          end

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'has a step of new_invoicing_address' do
            expect(controller.params[:facilities_management_procurement][:step]).to eq 'new_invoicing_address'
          end
        end
      end

      context 'when continuing to new notices contact details from the add address page' do
        let(:empty_notice_contact_detail) { create(:facilities_management_procurement_notices_contact_detail_empty, procurement: procurement) }
        let(:notices_contact_detail) { create(:facilities_management_procurement_notices_contact_detail) }

        before do
          procurement.update(da_journey_state: 'contract_details')
          procurement.update(notices_contact_detail: empty_notice_contact_detail)
        end

        context 'when a valid address is entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'new_notices_address', notices_contact_detail_attributes: contact_details_address_hash(empty_notice_contact_detail.id, notices_contact_detail) } }
          end

          it 'redirects to edit_facilities_management_procurement_path' do
            expect(response).to redirect_to edit_facilities_management_procurement_path(id: procurement.id, step: 'new_notices_contact_details')
          end

          it 'updates the procurement to have an address' do
            procurement.reload
            expect(procurement.notices_contact_detail.full_organisation_address).to eq notices_contact_detail.full_organisation_address
          end
        end

        context 'when an invalid address is entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'new_notices_address', notices_contact_detail_attributes: { id: empty_notice_contact_detail.id } } }
          end

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'has a step of new_notices_address' do
            expect(controller.params[:facilities_management_procurement][:step]).to eq 'new_notices_address'
          end
        end
      end

      context 'when continuing to new authorised representative details from the add address page' do
        let(:empty_authorised_contact_detail) { create(:facilities_management_procurement_authorised_contact_detail_empty, procurement: procurement) }
        let(:authorised_contact_detail) { create(:facilities_management_procurement_authorised_contact_detail) }

        before do
          procurement.update(da_journey_state: 'contract_details')
          procurement.update(authorised_contact_detail: empty_authorised_contact_detail)
        end

        context 'when a valid address is entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'new_authorised_representative_address', authorised_contact_detail_attributes: contact_details_address_hash(empty_authorised_contact_detail.id, authorised_contact_detail) } }
          end

          it 'redirects to edit_facilities_management_procurement_path' do
            expect(response).to redirect_to edit_facilities_management_procurement_path(id: procurement.id, step: 'new_authorised_representative_details')
          end

          it 'updates the procurement to have an address' do
            procurement.reload
            expect(procurement.authorised_contact_detail.full_organisation_address).to eq authorised_contact_detail.full_organisation_address
          end
        end

        context 'when an invalid address is entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'new_authorised_representative_address', authorised_contact_detail_attributes: { id: empty_authorised_contact_detail.id } } }
          end

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'has a step of new_authorised_representative_address' do
            expect(controller.params[:facilities_management_procurement][:step]).to eq 'new_authorised_representative_address'
          end
        end
      end

      def contact_details_hash(id, contact_detail)
        { id: id, name: contact_detail.name, job_title: contact_detail.job_title, email: contact_detail.email, telephone_number: contact_detail.telephone_number, organisation_address_line_1: contact_detail.organisation_address_line_1, organisation_address_town: contact_detail.organisation_address_town, organisation_address_postcode: contact_detail.organisation_address_postcode }
      end

      context 'when continuing to invoicing contact details from the new invoicing contact details page' do
        let(:empty_invoice_contact_detail) { create(:facilities_management_procurement_invoice_contact_detail_empty, procurement: procurement) }
        let(:invoice_contact_detail) { create(:facilities_management_procurement_invoice_contact_detail) }

        before do
          procurement.update(da_journey_state: 'contract_details')
          procurement.update(invoice_contact_detail: empty_invoice_contact_detail)
        end

        context 'when valid details are entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'new_invoicing_contact_details', invoice_contact_detail_attributes: contact_details_hash(empty_invoice_contact_detail.id, invoice_contact_detail) } }
          end

          it 'redirects to edit_facilities_management_procurement_path' do
            expect(response).to redirect_to edit_facilities_management_procurement_path(id: procurement.id, step: 'invoicing_contact_details')
          end

          it 'updates the procurement to have the full details' do
            procurement.reload
            procurement_invoicing_details = procurement.invoice_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_procurement_id')
            full_invoicing_details = invoice_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_procurement_id')

            expect(procurement_invoicing_details).to eq full_invoicing_details
          end
        end

        context 'when invalid details are entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'new_invoicing_contact_details', invoice_contact_detail_attributes: { id: empty_invoice_contact_detail.id } } }
          end

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'has a step of new_invoicing_address' do
            expect(controller.params[:facilities_management_procurement][:step]).to eq 'new_invoicing_contact_details'
          end
        end
      end

      context 'when continuing to notices contact details from new notices contact details' do
        let(:empty_notice_contact_detail) { create(:facilities_management_procurement_notices_contact_detail_empty, procurement: procurement) }
        let(:notices_contact_detail) { create(:facilities_management_procurement_notices_contact_detail) }

        before do
          procurement.update(da_journey_state: 'contract_details')
          procurement.update(notices_contact_detail: empty_notice_contact_detail)
        end

        context 'when valid details are entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'new_notices_contact_details', notices_contact_detail_attributes: contact_details_hash(empty_notice_contact_detail.id, notices_contact_detail) } }
          end

          it 'redirects to edit_facilities_management_procurement_path' do
            expect(response).to redirect_to edit_facilities_management_procurement_path(id: procurement.id, step: 'notices_contact_details')
          end

          it 'updates the procurement to have an address' do
            procurement.reload
            procurement_notices_details = procurement.notices_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_procurement_id')
            full_notices_details = notices_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_procurement_id')

            expect(procurement_notices_details).to eq full_notices_details
          end
        end

        context 'when invalid details are entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'new_notices_contact_details', notices_contact_detail_attributes: { id: empty_notice_contact_detail.id } } }
          end

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'has a step of new_notices_address' do
            expect(controller.params[:facilities_management_procurement][:step]).to eq 'new_notices_contact_details'
          end
        end
      end

      context 'when continuing to authorised representative details from new authorised representative details' do
        let(:empty_authorised_contact_detail) { create(:facilities_management_procurement_authorised_contact_detail_empty, procurement: procurement) }
        let(:authorised_contact_detail) { create(:facilities_management_procurement_authorised_contact_detail) }

        before do
          procurement.update(da_journey_state: 'contract_details')
          procurement.update(authorised_contact_detail: empty_authorised_contact_detail)
        end

        context 'when valid details are entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'new_authorised_representative_details', authorised_contact_detail_attributes: contact_details_hash(empty_authorised_contact_detail.id, authorised_contact_detail) } }
          end

          it 'redirects to edit_facilities_management_procurement_path' do
            expect(response).to redirect_to edit_facilities_management_procurement_path(id: procurement.id, step: 'authorised_representative')
          end

          it 'updates the procurement to have an address' do
            procurement.reload
            procurement_authorised_details = procurement.authorised_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_procurement_id')
            full_authorised_details = authorised_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_procurement_id')

            expect(procurement_authorised_details).to eq full_authorised_details
          end
        end

        context 'when invalid details are entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'new_authorised_representative_details', authorised_contact_detail_attributes: { id: empty_authorised_contact_detail.id } } }
          end

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'has a step of new_authorised_representative_details' do
            expect(controller.params[:facilities_management_procurement][:step]).to eq 'new_authorised_representative_details'
          end
        end
      end

      context 'when adding new pensions' do
        before do
          procurement.update(da_journey_state: 'contract_details')
        end

        context 'when valid pensions are entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'pension_funds', procurement_pension_funds_attributes: { '0': { case_sensitive_error: false, name: 'Pension 1', percentage: 10, "_destroy": false }, '1': { case_sensitive_error: false, name: 'Pension 2', percentage: 5, "_destroy": false }, '2': { case_sensitive_error: false, name: 'Pension 3', percentage: 2, "_destroy": false } } } }
          end

          it 'redirects to edit_facilities_management_procurement_path' do
            expect(response).to redirect_to facilities_management_procurement_path(id: procurement.id)
          end

          it 'updates the procurement to have the pensions' do
            procurement.reload
            pension_fund1 = procurement.procurement_pension_funds.order(:name)[0]
            pension_fund2 = procurement.procurement_pension_funds.order(:name)[1]
            pension_fund3 = procurement.procurement_pension_funds.order(:name)[2]

            expect([pension_fund1.attributes['name'], pension_fund1.attributes['percentage']]).to eq ['Pension 1', 10.0]
            expect([pension_fund2.attributes['name'], pension_fund2.attributes['percentage']]).to eq ['Pension 2', 5.0]
            expect([pension_fund3.attributes['name'], pension_fund3.attributes['percentage']]).to eq ['Pension 3', 2.0]
          end

          context 'when one of the pensions is deleted' do
            it 'updates the procurement to have 2 pensions' do
              procurement.reload
              pension_ids = procurement.procurement_pension_funds.order(:name).map(&:id)

              patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'pension_funds', procurement_pension_funds_attributes: { '0': { id: pension_ids[0], case_sensitive_error: false, name: 'Pension 1', percentage: 10, "_destroy": false }, '1': { id: pension_ids[1], case_sensitive_error: false, name: 'Pension 2', percentage: 5, "_destroy": false }, '2': { id: pension_ids[2], case_sensitive_error: false, name: 'Pension 3', percentage: 2, "_destroy": true } } } }
              expect(procurement.procurement_pension_funds.size).to eq 2
            end
          end
        end

        context 'when invalid pensions are entered' do
          before do
            patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'pension_funds', procurement_pension_funds_attributes: { '0': { case_sensitive_error: false, name: 'Pension 1', percentage: nil, "_destroy": false }, '1': { case_sensitive_error: false, name: nil, percentage: 10, "_destroy": false } } } }
          end

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'has a step of pension_funds' do
            expect(controller.params[:facilities_management_procurement][:step]).to eq 'pension_funds'
          end
        end
      end

      context 'when the user is adding regions' do
        let(:region_codes) { ['UKE1', 'UKI3', 'UKL11'] }

        before do
          patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'regions', region_codes: region_codes } }
        end

        it 'redirects to edit_facilities_management_procurement_path' do
          expect(response).to redirect_to facilities_management_procurement_path(id: procurement.id)
        end

        it 'updates the regions in the procurement' do
          procurement.reload
          expect(procurement.region_codes).to eq region_codes
        end
      end

      context 'when the user updates the service codes' do
        let(:service_codes) { ['C.1', 'O.1'] }
        let(:region_codes) { ['UKC1', 'UKN01'] }

        context 'when the user is in a quick search state' do
          context 'when the user selects service codes' do
            before do
              patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'services', service_codes: service_codes } }
            end

            it 'redirects to edit_facilities_management_procurement_path' do
              expect(response).to redirect_to facilities_management_procurement_path(id: procurement.id)
            end

            it 'updates the service codes' do
              procurement.reload
              expect(procurement.service_codes).to eq service_codes
            end
          end

          context 'when the user does not select service codes' do
            before do
              patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'services' } }
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
              patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'regions', region_codes: region_codes } }
            end

            it 'redirects to edit_facilities_management_procurement_path' do
              expect(response).to redirect_to facilities_management_procurement_path(id: procurement.id)
            end

            it 'updates the region codes' do
              procurement.reload
              expect(procurement.region_codes).to eq region_codes
            end
          end

          context 'when the user does not select region codes' do
            before do
              patch :update, params: { id: procurement.id, facilities_management_procurement: { step: 'regions' } }
            end

            it 'renders the edit page' do
              expect(response).to render_template('edit')
            end

            it 'has the correct error message' do
              expect(assigns(:procurement).errors[:region_codes].first).to eq 'Select at least one region you need to include in your procurement'
            end
          end
        end

        context 'when the user is in a detailed search state' do
          before do
            procurement.update(aasm_state: 'detailed_search')
          end

          context 'when next step is present in the params' do
            before do
              patch :update, params: { id: procurement.id, next_step: 'building_services', facilities_management_procurement: { step: 'services', service_codes: service_codes } }
            end

            it 'redirects to edit_facilities_management_procurement_path building services step' do
              expect(response).to redirect_to edit_facilities_management_procurement_path(id: procurement.id, step: 'building_services')
            end

            it 'updates the service codes' do
              procurement.reload
              expect(procurement.service_codes).to eq service_codes
            end
          end

          context 'when services is present in the params' do
            context 'when next_step is in the params' do
              context 'when services are selected' do
                before do
                  patch :update, params: { id: procurement.id, next_step: 'Save and continue', facilities_management_procurement: { step: 'services', service_codes: service_codes } }
                end

                it 'redirects to edit_facilities_management_procurement_path' do
                  expect(response).to redirect_to edit_facilities_management_procurement_path(id: procurement.id, step: 'building_services')
                end

                it 'updates the service codes' do
                  procurement.reload
                  expect(procurement.service_codes).to eq service_codes
                end
              end

              context 'when no services are slected' do
                it 'renders the edit page' do
                  patch :update, params: { id: procurement.id, next_step: 'Save and continue', facilities_management_procurement: { step: 'services' } }

                  expect(response).to render_template('edit')
                end
              end
            end

            context 'when save_and_return_to_detailed_summary is present' do
              context 'when services are selected' do
                before do
                  patch :update, params: { id: procurement.id, save_and_return_to_detailed_summary: 'Save and return to detailed search summary', facilities_management_procurement: { step: 'services', service_codes: service_codes } }
                end

                it 'redirects to facilities_management_procurement_path' do
                  expect(response).to redirect_to facilities_management_procurement_path(procurement)
                end

                it 'updates the service codes' do
                  procurement.reload
                  expect(procurement.service_codes).to eq service_codes
                end
              end

              context 'when no services are slected' do
                it 'renders the edit page' do
                  patch :update, params: { id: procurement.id, save_and_return_to_detailed_summary: 'Save and return to detailed search summary', facilities_management_procurement: { step: 'services' } }

                  expect(response).to render_template('edit')
                end
              end
            end
          end
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

        it 'redirects facilities_management_procurements_url' do
          expect(response).to redirect_to facilities_management_procurements_url(deleted: procurement.contract_name)
        end
      end
    end
  end

  # rubocop:disable RSpec/MessageSpies
  describe 'contact_details_data_setup' do
    login_fm_buyer_with_details

    before do
      procurement.update(aasm_state: 'da_draft')
      procurement.update(da_journey_state: 'contract_details')
    end

    context 'when adding invoicing contact details' do
      let(:invoice_contact_detail) { create(:facilities_management_procurement_invoice_contact_detail) }

      before do
        allow_any_instance_of(procurement.class).to receive(:build_invoice_contact_detail)
      end

      context 'when on new_invoicing_contact_details' do
        it 'builds new invoicing contact details' do
          get :edit, params: { id: procurement.id, step: 'new_invoicing_contact_details' }

          expect(assigns(:procurement)).to have_received(:build_invoice_contact_detail)
        end

        context 'when invoicing contact details already exist' do
          it 'does not build new invoicing contact details' do
            procurement.update(invoice_contact_detail: invoice_contact_detail)
            get :edit, params: { id: procurement.id, step: 'new_invoicing_contact_details' }

            expect(assigns(:procurement)).not_to receive(:build_invoice_contact_detail)
          end
        end
      end

      context 'when on new_invoicing_address' do
        it 'builds new invoicing contact details' do
          get :edit, params: { id: procurement.id, step: 'new_invoicing_address' }

          expect(assigns(:procurement)).to have_received(:build_invoice_contact_detail)
        end
      end
    end

    context 'when adding authorised representative contact details' do
      let(:authorised_contact_detail) { create(:facilities_management_procurement_authorised_contact_detail) }

      before do
        allow_any_instance_of(procurement.class).to receive(:build_authorised_contact_detail)
      end

      context 'when on new_authorised_representative_details' do
        it 'builds new invoicing contact details' do
          get :edit, params: { id: procurement.id, step: 'new_authorised_representative_details' }

          expect(assigns(:procurement)).to have_received(:build_authorised_contact_detail)
        end

        context 'when invoicing contact details already exist' do
          it 'does not build new invoicing contact details' do
            procurement.update(authorised_contact_detail: authorised_contact_detail)
            get :edit, params: { id: procurement.id, step: 'new_authorised_representative_details' }

            expect(assigns(:procurement)).not_to receive(:build_authorised_contact_detail)
          end
        end
      end

      context 'when on new_authorised_representative_address' do
        it 'builds new invoicing contact details' do
          get :edit, params: { id: procurement.id, step: 'new_authorised_representative_address' }

          expect(assigns(:procurement)).to have_received(:build_authorised_contact_detail)
        end
      end
    end

    context 'when adding notice contact details' do
      let(:notices_contact_detail) { create(:facilities_management_procurement_notices_contact_detail) }

      before do
        allow_any_instance_of(procurement.class).to receive(:build_notices_contact_detail)
      end

      context 'when on new_notices_contact_details' do
        it 'builds new notices contact details' do
          get :edit, params: { id: procurement.id, step: 'new_notices_contact_details' }

          expect(assigns(:procurement)).to have_received(:build_notices_contact_detail)
        end

        context 'when notices contact details already exist' do
          it 'does not build new notices contact details' do
            procurement.update(notices_contact_detail: notices_contact_detail)
            get :edit, params: { id: procurement.id, step: 'new_notices_contact_details' }

            expect(assigns(:procurement)).not_to receive(:build_notices_contact_detail)
          end
        end
      end

      context 'when on new_notices_address' do
        it 'builds new notices contact details' do
          get :edit, params: { id: procurement.id, step: 'new_notices_address' }

          expect(assigns(:procurement)).to have_received(:build_notices_contact_detail)
        end
      end
    end
  end
  # rubocop:enable RSpec/MessageSpies

  describe 'verify_completed_contact_details' do
    login_fm_buyer_with_details

    before do
      procurement.update(aasm_state: 'da_draft')
      procurement.update(da_journey_state: 'contract_details')
    end

    context 'when moving on and leaving pension funds uncompleted' do
      context 'when local_government_pension_scheme is not true' do
        before do
          procurement.update(local_government_pension_scheme: false)
          get :edit, params: { id: procurement.id, step: 'new_notices_address' }
        end

        it 'does not change local_government_pension_scheme' do
          expect(procurement.local_government_pension_scheme).to be false
        end
      end

      context 'when the step is pension_funds' do
        before do
          procurement.update(local_government_pension_scheme: true)
          create_list :facilities_management_procurement_pension_fund, 3, procurement: procurement
          get :edit, params: { id: procurement.id, step: 'pension_funds' }
        end

        it 'does not delete the pension funds' do
          expect(procurement.procurement_pension_funds.empty?).to be false
        end

        it 'does not change local_government_pension_scheme' do
          expect(procurement.local_government_pension_scheme).to be true
        end
      end

      context 'when the step is nil and pensions are not empty' do
        before do
          procurement.update(local_government_pension_scheme: true)
          create_list :facilities_management_procurement_pension_fund, 3, procurement: procurement
          get :show, params: { id: procurement.id }
        end

        it 'does not delete the pension funds' do
          expect(procurement.procurement_pension_funds.empty?).to be false
        end

        it 'does not change local_government_pension_scheme' do
          expect(procurement.local_government_pension_scheme).to be true
        end
      end

      context 'when the step is nil and pensions are empty' do
        before do
          procurement.update(local_government_pension_scheme: true)
          get :show, params: { id: procurement.id }
          procurement.reload
        end

        it 'does delete the pension funds' do
          expect(procurement.procurement_pension_funds.empty?).to be true
        end

        it 'does not change local_government_pension_scheme' do
          expect(procurement.local_government_pension_scheme).to be nil
        end
      end
    end

    context 'when moving on and leaving invoicing contact details' do
      context 'when the step is new_invoicing_contact_details' do
        it 'does not delete invoice_contact_detail' do
          create :facilities_management_procurement_invoice_contact_detail, procurement: procurement
          get :edit, params: { id: procurement.id, step: 'new_invoicing_contact_details' }
          procurement.reload

          expect(procurement.invoice_contact_detail.blank?).to be false
        end
      end

      context 'when the step is not new_invoicing_contact_details or new_invoicing_address' do
        it 'does not delete the invoice_contact_detail' do
          create :facilities_management_procurement_invoice_contact_detail, procurement: procurement
          get :edit, params: { id: procurement.id, step: 'new_authorised_representative_details' }
          procurement.reload

          expect(procurement.invoice_contact_detail.blank?).to be false
        end
      end

      context 'when the invoicing_contact_detail are incomplete' do
        it 'does delete the invoice_contact_detail' do
          create :facilities_management_procurement_invoice_contact_detail_empty, procurement: procurement
          get :edit, params: { id: procurement.id, step: 'new_authorised_representative_details' }
          procurement.reload

          expect(procurement.invoice_contact_detail.blank?).to be true
        end
      end
    end

    context 'when moving on and leaving authorised representative details' do
      context 'when the step is new_authorised_representative_details' do
        it 'does not delete authorised_contact_detail' do
          create :facilities_management_procurement_authorised_contact_detail, procurement: procurement
          get :edit, params: { id: procurement.id, step: 'new_authorised_representative_details' }
          procurement.reload

          expect(procurement.authorised_contact_detail.blank?).to be false
        end
      end

      context 'when the step is not new_invoicing_contact_details or new_invoicing_address' do
        it 'does not delete the invoice_contact_detail' do
          create :facilities_management_procurement_authorised_contact_detail, procurement: procurement
          get :edit, params: { id: procurement.id, step: 'new_authorised_representative_details' }
          procurement.reload

          expect(procurement.authorised_contact_detail.blank?).to be false
        end
      end

      context 'when the new_authorised_representative_details are incomplete' do
        it 'does delete the authorised_contact_detail' do
          create :facilities_management_procurement_authorised_contact_detail_empty, procurement: procurement
          get :edit, params: { id: procurement.id, step: 'new_notices_contact_details' }
          procurement.reload

          expect(procurement.authorised_contact_detail.blank?).to be true
        end
      end
    end

    context 'when moving on and leaving notice contact details' do
      context 'when the step is new_invoicing_contact_details' do
        it 'does not delete notices_contact_detail' do
          create :facilities_management_procurement_notices_contact_detail, procurement: procurement
          get :edit, params: { id: procurement.id, step: 'new_notices_contact_details' }
          procurement.reload

          expect(procurement.notices_contact_detail.blank?).to be false
        end
      end

      context 'when the step is not new_invoicing_contact_details or new_invoicing_address' do
        it 'does not delete the notices_contact_detail' do
          create :facilities_management_procurement_notices_contact_detail, procurement: procurement
          get :edit, params: { id: procurement.id, step: 'new_notices_contact_details' }
          procurement.reload

          expect(procurement.notices_contact_detail.blank?).to be false
        end
      end

      context 'when the invoicing_contact_detail are incomplete' do
        it 'does delete the notices_contact_detail' do
          create :facilities_management_procurement_notices_contact_detail_empty, procurement: procurement
          get :edit, params: { id: procurement.id, step: 'new_authorised_representative_details' }
          procurement.reload

          expect(procurement.notices_contact_detail.blank?).to be true
        end
      end
    end
  end

  context 'when logging in as a different fm buyer than the one that created the procurement' do
    login_fm_buyer_with_details

    it 'redirects to the not permitted page' do
      procurement.update(aasm_state: 'detailed_search', user_id: create(:user).id)
      patch :update, params: { id: procurement.id, step: 'name', facilities_management_procurement: { contract_name: 'Updated name' } }
      expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
    end
  end
end
# rubocop:enable RSpec/NestedGroups
# rubocop:enable RSpec/AnyInstance
