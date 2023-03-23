require 'rails_helper'

# rubocop:disable RSpec/NestedGroups
RSpec.describe FacilitiesManagement::RM3830::Procurements::ContractDetailsController do
  let(:default_params) { { service: 'facilities_management', framework: framework } }
  let(:framework) { 'RM3830' }
  let(:procurement) { create(:facilities_management_rm3830_procurement, user: subject.current_user, aasm_state: 'da_draft') }

  login_fm_buyer_with_details

  describe 'GET show' do
    context 'when the procurement is not in da draft' do
      other_states = %i[quick_search detailed_search detailed_search_bulk_upload choose_contract_value results direct_award further_competition closed]

      before do
        procurement.update(aasm_state: state)
        get :show, params: { procurement_id: procurement.id }
      end

      other_states.each do |aasm_state|
        context "and the state is #{aasm_state}" do
          let(:state) { aasm_state }

          it 'redirects to the procurements_controller' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
          end
        end
      end
    end

    context 'when the procurement is in a da_draft state' do
      it 'renders the show template' do
        get :show, params: { procurement_id: procurement.id }

        expect(response).to render_template('show')
      end
    end

    context 'when considering the different states for da_draft' do
      before do
        procurement.update(da_journey_state: state)
        get :show, params: { procurement_id: procurement.id }
      end

      da_journey_states = %i[pricing what_next important_information contract_details review_and_generate review sending]

      da_journey_states.each do |da_journey_state|
        context "when da_journey_state is #{da_journey_state}" do
          let(:state) { da_journey_state }

          it "sets the page_name to #{da_journey_state}" do
            expect(assigns(:page_name)).to eq da_journey_state
          end
        end
      end
    end
  end

  describe 'GET edit' do
    context 'when the procurement is not in da draft' do
      other_states = %i[quick_search detailed_search detailed_search_bulk_upload choose_contract_value results direct_award further_competition closed]

      before do
        procurement.update(aasm_state: state)
        get :edit, params: { procurement_id: procurement.id, page: 'payment_method' }
      end

      other_states.each do |aasm_state|
        context "and the state is #{aasm_state}" do
          let(:state) { aasm_state }

          it 'redirects to the procurements_controller' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
          end
        end
      end
    end

    context 'when the procurement is in a da_draft state' do
      before { procurement.update(da_journey_state: 'contract_details') }

      it 'renders the edit template' do
        get :edit, params: { procurement_id: procurement.id, page: 'payment_method' }

        expect(response).to render_template('edit')
      end
    end

    context 'when considering the different states for da_draft that are not contract_details' do
      before do
        procurement.update(da_journey_state: state)
        get :edit, params: { procurement_id: procurement.id, page: 'payment_method' }
      end

      da_journey_states = %i[pricing what_next important_information review_and_generate review sending]

      da_journey_states.each do |da_journey_state|
        context "when da_journey_state is #{da_journey_state}" do
          let(:state) { da_journey_state }

          it 'redirects to the show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end
        end
      end
    end

    context 'when considering the edit pages for contact_details' do
      before do
        procurement.update(da_journey_state: 'contract_details')
        get :edit, params: { procurement_id: procurement.id, page: page }
      end

      context 'when the page is not recognised' do
        let(:page) { 'payment_period' }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
        end
      end

      context 'when updating payment method' do
        let(:page) { 'payment_method' }

        it 'will render the edit template' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of payment_method' do
          expect(assigns(:page_name)).to eq :payment_method
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to contract details'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_path
        end
      end

      context 'when on Invoicing contact details page' do
        let(:page) { 'invoicing_contact_details' }

        it 'will render the edit template' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of invoicing_contact_details' do
          expect(assigns(:page_name)).to eq :invoicing_contact_details
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to contract details'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_path
        end
      end

      context 'when on New invoicing contact details page' do
        let(:page) { 'new_invoicing_contact_details' }

        it 'will render the edit template' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of new_invoicing_contact_details' do
          expect(assigns(:page_name)).to eq :new_invoicing_contact_details
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to invoicing contact details'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'invoicing_contact_details')
        end
      end

      context 'when on New invoicing address page' do
        let(:page) { 'new_invoicing_contact_details_address' }

        it 'will render the edit template' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of new_invoicing_contact_details_address' do
          expect(assigns(:page_name)).to eq :new_invoicing_contact_details_address
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to new invoicing contact details'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'new_invoicing_contact_details')
        end
      end

      context 'when on Authorised representative details page' do
        let(:page) { 'authorised_representative' }

        it 'will render the edit template' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of authorised_representative' do
          expect(assigns(:page_name)).to eq :authorised_representative
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to contract details'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_path
        end
      end

      context 'when on New authorised representative details page' do
        let(:page) { 'new_authorised_representative' }

        it 'will render the edit template' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of new_authorised_representative' do
          expect(assigns(:page_name)).to eq :new_authorised_representative
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to authorised representative details'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'authorised_representative')
        end
      end

      context 'when on New authorised representative details address page' do
        let(:page) { 'new_authorised_representative_address' }

        it 'will render the edit template' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of new_authorised_representative_address' do
          expect(assigns(:page_name)).to eq :new_authorised_representative_address
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to new authorised representative details'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'new_authorised_representative')
        end
      end

      context 'when on Notices contact details details page' do
        let(:page) { 'notices_contact_details' }

        it 'will render the edit template' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of notices_contact_details' do
          expect(assigns(:page_name)).to eq :notices_contact_details
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to contract details'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_path
        end
      end

      context 'when on New notices contact details page' do
        let(:page) { 'new_notices_contact_details' }

        it 'will render the edit template' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of new_notices_contact_details' do
          expect(assigns(:page_name)).to eq :new_notices_contact_details
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to notices contact details'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'notices_contact_details')
        end
      end

      context 'when on New notices contact details address page' do
        let(:page) { 'new_notices_contact_details_address' }

        it 'will render the edit template' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of new_notices_contact_details_address' do
          expect(assigns(:page_name)).to eq :new_notices_contact_details_address
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to new notices contact details'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'new_notices_contact_details')
        end
      end

      context 'when on Security policy document page' do
        let(:page) { 'security_policy_document' }

        it 'will render the edit template' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of security_policy_document' do
          expect(assigns(:page_name)).to eq :security_policy_document
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to contract details'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_path
        end
      end

      context 'when on Local government pension scheme page' do
        let(:page) { 'local_government_pension_scheme' }

        it 'will render the edit template' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of local_government_pension_scheme' do
          expect(assigns(:page_name)).to eq :local_government_pension_scheme
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to contract details'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_path
        end
      end

      context 'when on Pension funds page' do
        let(:page) { 'pension_funds' }

        it 'will render the edit template' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of pension_funds' do
          expect(assigns(:page_name)).to eq :pension_funds
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to Local Government Pension Scheme'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'local_government_pension_scheme')
        end
      end

      context 'when selecting the governing law question' do
        render_views
        let(:page) { 'governing_law' }

        it 'will render the edit view' do
          expect(response).to render_template('edit')
        end

        it 'will have a page_name of governing_law' do
          expect(assigns(:page_name)).to eq :governing_law
        end

        it 'has links to documents' do
          expect(response.body).to match(/core terms/i)
          expect(response.body).to match(/schedule 24/i)
          expect(response.body).to match(/schedule 25/i)
        end

        it 'has governing law options' do
          expect(response.body).to match(/english law/i)
          expect(response.body).to match(/scottish law/i)
          expect(response.body).to match(/northern ireland law/i)
        end

        it 'has correct backlink text and destination' do
          expect(assigns(:page_description).back_button.text).to eq 'Return to contract details'
          expect(assigns(:page_description).back_button.url).to eq facilities_management_rm3830_procurement_contract_details_path
        end
      end
    end
  end

  describe 'PUT update' do
    context 'when updating contract details' do
      before { procurement.update(da_journey_state: 'contract_details') }

      context 'when on the payment method page' do
        before do
          put :update, params: { procurement_id: procurement.id, page: 'payment_method', facilities_management_rm3830_procurement: { payment_method: payment_method } }
        end

        context 'when nothing is selected' do
          let(:payment_method) { nil }

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'sets the page as payment_method' do
            expect(assigns(:page_name)).to eq :payment_method
          end
        end

        context 'when a valid option is selected' do
          let(:payment_method) { 'bacs' }

          it 'redirects to show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end

          it 'updates payment_method' do
            expect(procurement.reload.payment_method).to eq payment_method
          end
        end

        context 'when an invalid option is selected' do
          let(:payment_method) { 'mashed_potato' }

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end
        end
      end

      context 'when continuing from invoicing contact details' do
        let(:invoice_contact_detail) { nil }

        before do
          procurement.invoice_contact_detail = invoice_contact_detail
          put :update, params: { procurement_id: procurement.id, page: 'invoicing_contact_details', facilities_management_rm3830_procurement: { using_buyer_detail_for_invoice_details: using_buyer_detail_for_invoice_details } }
        end

        context 'when not using existing invoicing contact details' do
          let(:using_buyer_detail_for_invoice_details) { false }

          context 'and invoicing contact details exist' do
            let(:invoice_contact_detail) { create(:facilities_management_rm3830_procurement_invoice_contact_detail, procurement: procurement) }

            it 'will redirect to facilities_management_rm3830_procurement_contract_details_path if the invoice_contact_detail is not blank' do
              expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
            end
          end

          context 'and invoicing contact details do exist' do
            it 'will redirect to facilities_management_rm3830_procurement_contract_details_edit_path if the invoicing contact details are blank' do
              expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'new_invoicing_contact_details')
            end
          end
        end

        context 'when using existing invoicing contact details' do
          let(:using_buyer_detail_for_invoice_details) { true }

          it 'will redirect to the show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end
        end

        context 'when no option is selected' do
          let(:using_buyer_detail_for_invoice_details) { nil }

          it 'will render the edit page' do
            expect(response).to render_template('edit')
          end

          it 'will have a inclusion error on the procurement' do
            expect(assigns(:procurement).errors[:using_buyer_detail_for_invoice_details].any?).to be true
          end
        end
      end

      context 'when continuing from authorised contact details' do
        let(:authorised_contact_detail) { nil }

        before do
          procurement.authorised_contact_detail = authorised_contact_detail
          put :update, params: { procurement_id: procurement.id, page: 'authorised_representative', facilities_management_rm3830_procurement: { using_buyer_detail_for_authorised_detail: using_buyer_detail_for_authorised_detail } }
        end

        context 'when not using existing authorised contact details' do
          let(:using_buyer_detail_for_authorised_detail) { false }

          context 'and authorised contact details exist' do
            let(:authorised_contact_detail) { create(:facilities_management_rm3830_procurement_authorised_contact_detail, procurement: procurement) }

            it 'will redirect to facilities_management_rm3830_procurement_contract_details_path if the invoice_contact_detail is not blank' do
              expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
            end
          end

          context 'and authorised contact details do exist' do
            it 'will redirect to facilities_management_rm3830_procurement_contract_details_edit_path if the authorised contact details are blank' do
              expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'new_authorised_representative')
            end
          end
        end

        context 'when using existing authorised contact details' do
          let(:using_buyer_detail_for_authorised_detail) { true }

          it 'will redirect to the show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end
        end

        context 'when no option is selected' do
          let(:using_buyer_detail_for_authorised_detail) { nil }

          it 'will render the edit page' do
            expect(response).to render_template('edit')
          end

          it 'will have a inclusion error on the procurement' do
            expect(assigns(:procurement).errors[:using_buyer_detail_for_authorised_detail].any?).to be true
          end
        end
      end

      context 'when continuing from notices contact details' do
        let(:notices_contact_detail) { nil }

        before do
          procurement.notices_contact_detail = notices_contact_detail
          put :update, params: { procurement_id: procurement.id, page: 'notices_contact_details', facilities_management_rm3830_procurement: { using_buyer_detail_for_notices_detail: using_buyer_detail_for_notices_detail } }
        end

        context 'when not using existing notices contact details' do
          let(:using_buyer_detail_for_notices_detail) { false }

          context 'and notices contact details exist' do
            let(:notices_contact_detail) { create(:facilities_management_rm3830_procurement_notices_contact_detail, procurement: procurement) }

            it 'will redirect to facilities_management_rm3830_procurement_contract_details_path if the invoice_contact_detail is not blank' do
              expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
            end
          end

          context 'and notices contact details do exist' do
            it 'will redirect to facilities_management_rm3830_procurement_contract_details_edit_path if the notices contact details are blank' do
              expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'new_notices_contact_details')
            end
          end
        end

        context 'when using existing notices contact details' do
          let(:using_buyer_detail_for_notices_detail) { true }

          it 'will redirect to the show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end
        end

        context 'when no option is selected' do
          let(:using_buyer_detail_for_notices_detail) { nil }

          it 'will render the edit page' do
            expect(response).to render_template('edit')
          end

          it 'will have a inclusion error on the procurement' do
            expect(assigns(:procurement).errors[:using_buyer_detail_for_notices_detail].any?).to be true
          end
        end
      end

      def contact_details_hash(id, contact_detail)
        { id: id, name: contact_detail.name, job_title: contact_detail.job_title, email: contact_detail.email, telephone_number: contact_detail.telephone_number, organisation_address_line_1: contact_detail.organisation_address_line_1, organisation_address_town: contact_detail.organisation_address_town, organisation_address_postcode: contact_detail.organisation_address_postcode }
      end

      context 'when continuing to invoicing contact details from the new invoicing contact details page' do
        let(:empty_invoice_contact_detail) { create(:facilities_management_rm3830_procurement_invoice_contact_detail_empty, procurement: procurement) }
        let(:invoice_contact_detail) { create(:facilities_management_rm3830_procurement_invoice_contact_detail) }

        before do
          procurement.update(invoice_contact_detail: empty_invoice_contact_detail)
          put :update, params: { procurement_id: procurement.id, page: 'new_invoicing_contact_details', facilities_management_rm3830_procurement: { invoice_contact_detail_attributes: address_attributes } }
        end

        context 'when valid details are entered' do
          let(:address_attributes) { contact_details_hash(empty_invoice_contact_detail.id, invoice_contact_detail) }

          it 'redirects to facilities_management_rm3830_procurement_contract_details_edit_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'invoicing_contact_details')
          end

          it 'updates the procurement to have the full details' do
            procurement.reload
            procurement_invoicing_details = procurement.invoice_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_rm3830_procurement_id')
            full_invoicing_details = invoice_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_rm3830_procurement_id')

            expect(procurement_invoicing_details).to eq full_invoicing_details
          end
        end

        context 'when invalid details are entered' do
          let(:address_attributes) { { id: empty_invoice_contact_detail.id } }

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'sets the page as new_invoicing_contact_details' do
            expect(assigns(:page_name)).to eq :new_invoicing_contact_details
          end
        end
      end

      context 'when continuing to authorised representative details from the new authorised representative details page' do
        let(:empty_authorised_contact_detail) { create(:facilities_management_rm3830_procurement_authorised_contact_detail_empty, procurement: procurement) }
        let(:authorised_contact_detail) { create(:facilities_management_rm3830_procurement_authorised_contact_detail) }

        before do
          procurement.update(authorised_contact_detail: empty_authorised_contact_detail)
          put :update, params: { procurement_id: procurement.id, page: 'new_authorised_representative', facilities_management_rm3830_procurement: { authorised_contact_detail_attributes: address_attributes } }
        end

        context 'when valid details are entered' do
          let(:address_attributes) { contact_details_hash(empty_authorised_contact_detail.id, authorised_contact_detail) }

          it 'redirects to facilities_management_rm3830_procurement_contract_details_edit_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'authorised_representative')
          end

          it 'updates the procurement to have the full details' do
            procurement.reload
            procurement_authorised_details = procurement.authorised_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_rm3830_procurement_id')
            full_authorised_details = authorised_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_rm3830_procurement_id')

            expect(procurement_authorised_details).to eq full_authorised_details
          end
        end

        context 'when invalid details are entered' do
          let(:address_attributes) { { id: empty_authorised_contact_detail.id } }

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'sets the page as new_authorised_representative' do
            expect(assigns(:page_name)).to eq :new_authorised_representative
          end
        end
      end

      context 'when continuing to notices contact details from the new notices contact details page' do
        let(:empty_notices_contact_detail) { create(:facilities_management_rm3830_procurement_notices_contact_detail_empty, procurement: procurement) }
        let(:notices_contact_detail) { create(:facilities_management_rm3830_procurement_notices_contact_detail) }

        before do
          procurement.update(notices_contact_detail: empty_notices_contact_detail)
          put :update, params: { procurement_id: procurement.id, page: 'new_notices_contact_details', facilities_management_rm3830_procurement: { notices_contact_detail_attributes: address_attributes } }
        end

        context 'when valid details are entered' do
          let(:address_attributes) { contact_details_hash(empty_notices_contact_detail.id, notices_contact_detail) }

          it 'redirects to facilities_management_rm3830_procurement_contract_details_edit_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'notices_contact_details')
          end

          it 'updates the procurement to have the full details' do
            procurement.reload
            procurement_notices_details = procurement.notices_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_rm3830_procurement_id')
            full_notices_details = notices_contact_detail.attributes.except('id', 'created_at', 'updated_at', 'facilities_management_rm3830_procurement_id')

            expect(procurement_notices_details).to eq full_notices_details
          end
        end

        context 'when invalid details are entered' do
          let(:address_attributes) { { id: empty_notices_contact_detail.id } }

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'sets the page as new_notices_contact_details' do
            expect(assigns(:page_name)).to eq :new_notices_contact_details
          end
        end
      end

      def contact_details_address_hash(id, contact_detail)
        { id: id, organisation_address_line_1: contact_detail.organisation_address_line_1, organisation_address_town: contact_detail.organisation_address_town, organisation_address_postcode: contact_detail.organisation_address_postcode }
      end

      context 'when continuing to new invoicing contact details from the add address page' do
        let(:empty_invoice_contact_detail) { create(:facilities_management_rm3830_procurement_invoice_contact_detail_empty, procurement: procurement) }
        let(:invoice_contact_detail) { create(:facilities_management_rm3830_procurement_invoice_contact_detail) }

        before do
          procurement.update(invoice_contact_detail: empty_invoice_contact_detail)
          put :update, params: { procurement_id: procurement.id, page: 'new_invoicing_contact_details_address', facilities_management_rm3830_procurement: { invoice_contact_detail_attributes: address_attributes } }
        end

        context 'when a valid address is entered' do
          let(:address_attributes) { contact_details_address_hash(empty_invoice_contact_detail.id, invoice_contact_detail) }

          it 'redirects to facilities_management_rm3830_procurement_contract_details_edit_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'new_invoicing_contact_details')
          end

          it 'updates the procurement to have an address' do
            procurement.reload
            expect(procurement.invoice_contact_detail.full_organisation_address).to eq invoice_contact_detail.full_organisation_address
          end
        end

        context 'when an invalid address is entered' do
          let(:address_attributes) { { id: empty_invoice_contact_detail.id } }

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'sets the page as new_invoicing_contact_details_address' do
            expect(assigns(:page_name)).to eq :new_invoicing_contact_details_address
          end
        end
      end

      context 'when continuing to new authorised representative details from the add address page' do
        let(:empty_authorised_contact_detail) { create(:facilities_management_rm3830_procurement_authorised_contact_detail_empty, procurement: procurement) }
        let(:authorised_contact_detail) { create(:facilities_management_rm3830_procurement_authorised_contact_detail) }

        before do
          procurement.update(authorised_contact_detail: empty_authorised_contact_detail)
          put :update, params: { procurement_id: procurement.id, page: 'new_authorised_representative_address', facilities_management_rm3830_procurement: { authorised_contact_detail_attributes: address_attributes } }
        end

        context 'when a valid address is entered' do
          let(:address_attributes) { contact_details_address_hash(empty_authorised_contact_detail.id, authorised_contact_detail) }

          it 'redirects to facilities_management_rm3830_procurement_contract_details_edit_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'new_authorised_representative')
          end

          it 'updates the procurement to have an address' do
            procurement.reload
            expect(procurement.authorised_contact_detail.full_organisation_address).to eq authorised_contact_detail.full_organisation_address
          end
        end

        context 'when an invalid address is entered' do
          let(:address_attributes) { { id: empty_authorised_contact_detail.id } }

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'sets the page as new_authorised_representative_address' do
            expect(assigns(:page_name)).to eq :new_authorised_representative_address
          end
        end
      end

      context 'when continuing to new notices details from the add address page' do
        let(:empty_notices_contact_detail) { create(:facilities_management_rm3830_procurement_notices_contact_detail_empty, procurement: procurement) }
        let(:notices_contact_detail) { create(:facilities_management_rm3830_procurement_notices_contact_detail) }

        before do
          procurement.update(notices_contact_detail: empty_notices_contact_detail)
          put :update, params: { procurement_id: procurement.id, page: 'new_notices_contact_details_address', facilities_management_rm3830_procurement: { notices_contact_detail_attributes: address_attributes } }
        end

        context 'when a valid address is entered' do
          let(:address_attributes) { contact_details_address_hash(empty_notices_contact_detail.id, notices_contact_detail) }

          it 'redirects to facilities_management_rm3830_procurement_contract_details_edit_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'new_notices_contact_details')
          end

          it 'updates the procurement to have an address' do
            procurement.reload
            expect(procurement.notices_contact_detail.full_organisation_address).to eq notices_contact_detail.full_organisation_address
          end
        end

        context 'when an invalid address is entered' do
          let(:address_attributes) { { id: empty_notices_contact_detail.id } }

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'sets the page as new_notices_contact_details_address' do
            expect(assigns(:page_name)).to eq :new_notices_contact_details_address
          end
        end
      end

      context 'when on Security policy document page' do
        context 'when nothing is selected' do
          before { put :update, params: { procurement_id: procurement.id, page: 'security_policy_document', facilities_management_rm3830_procurement: { security_policy_document_required: nil } } }

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'sets the page as security_policy_document' do
            expect(assigns(:page_name)).to eq :security_policy_document
          end
        end

        context 'when no is selected' do
          before { put :update, params: { procurement_id: procurement.id, page: 'security_policy_document', facilities_management_rm3830_procurement: { security_policy_document_required: false } } }

          it 'redirects to show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end

          it 'updates security_policy_document' do
            expect(procurement.reload.security_policy_document_required).to be false
          end
        end

        context 'when yes is selected' do
          let(:security_policy_document_name) { 'Security policy document file' }
          let(:security_policy_document_version_number) { '26' }

          before { put :update, params: { procurement_id: procurement.id, page: 'security_policy_document', facilities_management_rm3830_procurement: { security_policy_document_required: true, security_policy_document_name: security_policy_document_name, security_policy_document_version_number: security_policy_document_version_number, security_policy_document_file: security_policy_document_file } } }

          context 'and the file is invalid' do
            let(:security_policy_document_file) { fixture_file_upload(FacilitiesManagement::RM3830::SpreadsheetImporter::TEMPLATE_FILE_PATH, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }

            it 'renders the edit page' do
              expect(response).to render_template('edit')
            end

            it 'deletes the file' do
              expect(assigns(:procurement).reload.security_policy_document_file.attachment.present?).to be false
            end
          end

          context 'and all the details are valid' do
            let(:security_policy_document_file) { fixture_file_upload(Rails.public_path.join('facilities-management', 'rm3830', 'Attachment 1 - About the Direct Award v3.0.pdf'), 'application/pdf') }

            it 'redirects to show page' do
              expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
            end

            it 'updates security_policy_document' do
              procurement.reload
              expect(procurement.security_policy_document_name).to eq 'Security policy document file'
              expect(procurement.security_policy_document_version_number).to eq security_policy_document_version_number
              expect(procurement.security_policy_document_file.attachment.present?).to be true
            end
          end
        end
      end

      context 'when on the Local Government Pension Scheme page' do
        before do
          put :update, params: { procurement_id: procurement.id, page: 'local_government_pension_scheme', facilities_management_rm3830_procurement: { local_government_pension_scheme: local_government_pension_scheme } }
        end

        context 'when nothing is selected' do
          let(:local_government_pension_scheme) { nil }

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'sets the page as local_government_pension_scheme' do
            expect(assigns(:page_name)).to eq :local_government_pension_scheme
          end
        end

        context 'when yes is selected' do
          let(:local_government_pension_scheme) { true }

          it 'redirects to facilities_management_rm3830_procurement_contract_details_edit_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_edit_path(procurement, page: 'pension_funds')
          end
        end

        context 'when no is selected' do
          let(:local_government_pension_scheme) { false }

          it 'redirects to facilities_management_rm3830_procurement_contract_details_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end
        end
      end

      context 'when adding new pensions' do
        before do
          put :update, params: { procurement_id: procurement.id, page: 'pension_funds', facilities_management_rm3830_procurement: { procurement_pension_funds_attributes: procurement_pension_funds_attributes } }
        end

        context 'when valid pensions are entered' do
          let(:procurement_pension_funds_attributes) { { '0': { case_sensitive_error: false, name: 'Pension 1', percentage: 10, _destroy: false }, '1': { case_sensitive_error: false, name: 'Pension 2', percentage: 5, _destroy: false }, '2': { case_sensitive_error: false, name: 'Pension 3', percentage: 2, _destroy: false } } }

          it 'redirects to facilities_management_rm3830_procurement_contract_details_path' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
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

              put :update, params: { procurement_id: procurement.id, page: 'pension_funds', facilities_management_rm3830_procurement: { procurement_pension_funds_attributes: { '0': { id: pension_ids[0], case_sensitive_error: false, name: 'Pension 1', percentage: 10, _destroy: false }, '1': { id: pension_ids[1], case_sensitive_error: false, name: 'Pension 2', percentage: 5, _destroy: false }, '2': { id: pension_ids[2], case_sensitive_error: false, name: 'Pension 3', percentage: 2, _destroy: true } } } }
              expect(procurement.procurement_pension_funds.size).to eq 2
            end
          end
        end

        context 'when invalid pensions are entered' do
          let(:procurement_pension_funds_attributes) { { '0': { case_sensitive_error: false, name: 'Pension 1', percentage: nil, _destroy: false }, '1': { case_sensitive_error: false, name: nil, percentage: 10, _destroy: false } } }

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'sets the page as pension_funds' do
            expect(assigns(:page_name)).to eq :pension_funds
          end
        end
      end

      context 'when on the governing law page' do
        before do
          put :update, params: { procurement_id: procurement.id, page: 'governing_law', facilities_management_rm3830_procurement: { governing_law: governing_law } }
        end

        context 'when nothing is selected' do
          let(:governing_law) { nil }

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end

          it 'sets the page as governing_law' do
            expect(assigns(:page_name)).to eq :governing_law
          end
        end

        context 'when a valid option is selected' do
          let(:governing_law) { 'english' }

          it 'redirects to show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end

          it 'updates governing_law' do
            expect(procurement.reload.governing_law).to eq governing_law
          end
        end

        context 'when an invalid option is selected' do
          let(:governing_law) { 'fried_eggs' }

          it 'renders the edit page' do
            expect(response).to render_template('edit')
          end
        end
      end
    end

    context 'when navigating the da journey' do
      context 'when the state is pricing' do
        before do
          procurement.update(da_journey_state: 'pricing')
        end

        context 'when continuing the journey' do
          before { put :update, params: { procurement_id: procurement.id, page: 'pricing', continue_da: 'Continue to direct award' } }

          it 'redirects to the contract details show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end

          it 'updates the da_journey_state to what_next' do
            expect(procurement.reload.what_next?).to be true
          end
        end

        context 'when returning to results' do
          before { put :update, params: { procurement_id: procurement.id, page: 'pricing', return_to_results: 'Return to results' } }

          it 'redirects to the procurement show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
          end

          it 'updates the aasm_state to results' do
            expect(procurement.reload.results?).to be true
          end
        end
      end

      context 'when the state is what_next' do
        before do
          procurement.update(da_journey_state: 'what_next')
        end

        context 'when continuing the journey' do
          before { put :update, params: { procurement_id: procurement.id, page: 'what_next', continue_da: 'Continue to direct award' } }

          it 'redirects to the contract details show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end

          it 'updates the da_journey_state to important_information' do
            expect(procurement.reload.important_information?).to be true
          end
        end

        context 'when returning to results' do
          before { put :update, params: { procurement_id: procurement.id, page: 'what_next', return_to_results: 'Return to results' } }

          it 'redirects to the procurement show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
          end

          it 'updates the aasm_state to results' do
            expect(procurement.reload.results?).to be true
          end
        end
      end

      context 'when the state is important_information' do
        before do
          procurement.update(da_journey_state: 'important_information')
        end

        context 'when continuing the journey' do
          before { put :update, params: { procurement_id: procurement.id, page: 'important_information', continue_da: 'Continue' } }

          it 'redirects to the contract details show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end

          it 'updates the da_journey_state to contract_details' do
            expect(procurement.reload.contract_details?).to be true
          end
        end

        context 'when returning to results' do
          before { put :update, params: { procurement_id: procurement.id, page: 'important_information', return_to_results: 'Return to results' } }

          it 'redirects to the procurement show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
          end

          it 'updates the aasm_state to results' do
            expect(procurement.reload.results?).to be true
          end
        end
      end

      context 'when the state is contract_details' do
        before do
          procurement.update(da_journey_state: 'contract_details')
        end

        context 'when continuing the journey' do
          context 'when the procurement is valid' do
            let(:procurement) { create(:facilities_management_rm3830_procurement_with_contact_details, user: subject.current_user, aasm_state: 'da_draft') }

            before { put :update, params: { procurement_id: procurement.id, page: 'contract_details', continue_da: 'Continue' } }

            it 'redirects to the contract details show page' do
              expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
            end

            it 'updates the da_journey_state to review_and_generate' do
              expect(procurement.reload.review_and_generate?).to be true
            end
          end

          context 'when the procurement is invalid' do
            before { put :update, params: { procurement_id: procurement.id, page: 'contract_details', continue_da: 'Continue' } }

            it 'renders show when invalid' do
              expect(response).to render_template('show')
            end

            it 'does not change the da_journey_state when invalid' do
              expect(procurement.reload.contract_details?).to be true
            end
          end
        end

        context 'when returning to results' do
          before { put :update, params: { procurement_id: procurement.id, page: 'contract_details', return_to_results: 'Return to results' } }

          it 'redirects to the procurement show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
          end

          it 'updates the aasm_state to results' do
            expect(procurement.reload.results?).to be true
          end
        end
      end

      context 'when the state is review_and_generate' do
        before do
          procurement.update(da_journey_state: 'review_and_generate')
        end

        context 'when continuing the journey' do
          before { put :update, params: { procurement_id: procurement.id, page: 'review_and_generate', continue_da: 'Generate documents' } }

          it 'redirects to the contract details show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end

          it 'updates the da_journey_state to review' do
            expect(procurement.reload.review?).to be true
          end
        end

        context 'when changing requirements' do
          before { put :update, params: { procurement_id: procurement.id, page: 'review_and_generate', change_requirements: 'Change requirements' } }

          it 'redirects to the procurement show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
          end

          it 'updates the aasm_state to detailed_search' do
            expect(procurement.reload.detailed_search?).to be true
          end
        end

        context 'when changing contact details' do
          before { put :update, params: { procurement_id: procurement.id, page: 'review_and_generate', change_contract_details: 'Change contact details' } }

          it 'redirects to the contract details show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end

          it 'updates the da_journey_state to contract_details' do
            expect(procurement.reload.contract_details?).to be true
          end
        end

        context 'when returning to results' do
          before { put :update, params: { procurement_id: procurement.id, page: 'review_and_generate', return_to_results: 'Return to results' } }

          it 'redirects to the procurement show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
          end

          it 'updates the aasm_state to results' do
            expect(procurement.reload.results?).to be true
          end
        end
      end

      context 'when the state is review' do
        before do
          procurement.update(da_journey_state: 'review')
        end

        context 'when continuing the journey' do
          before { put :update, params: { procurement_id: procurement.id, page: 'review', continue_da: 'Create final contract and send to supplier' } }

          it 'redirects to the contract details show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end

          it 'updates the da_journey_state to sending' do
            expect(procurement.reload.sending?).to be true
          end
        end

        context 'when returning to review and generate' do
          before { put :update, params: { procurement_id: procurement.id, page: 'review', return_to_review_and_generate: 'Return to review and generate' } }

          it 'redirects to the contract details show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end

          it 'updates the da_journey_state to review_and_generate' do
            expect(procurement.reload.review_and_generate?).to be true
          end
        end

        context 'when returning to results' do
          before { put :update, params: { procurement_id: procurement.id, page: 'review', return_to_results: 'Return to results' } }

          it 'redirects to the procurement show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
          end

          it 'updates the aasm_state to results' do
            expect(procurement.reload.results?).to be true
          end
        end
      end

      context 'when the state is sending' do
        before do
          procurement.update(da_journey_state: 'sending')
        end

        context 'when continuing the journey' do
          let(:contract) { procurement.procurement_suppliers.create(direct_award_value: 123456, supplier: create(:facilities_management_rm3830_supplier_detail)) }

          before do
            contract
            # rubocop:disable RSpec/AnyInstance
            allow_any_instance_of(procurement.class).to receive(:offer_to_next_supplier)
            # rubocop:enable RSpec/AnyInstance
            put :update, params: { procurement_id: procurement.id, page: 'sending', continue_da: 'Confirm and send contract to supplier' }
          end

          it 'redirects to the sent page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_sent_index_path(procurement_id: procurement.id, contract_id: contract.id)
          end

          it 'updates the da_journey_state to sent' do
            expect(procurement.reload.sent?).to be true
          end

          it 'updates the aasm_state to direct_award' do
            expect(procurement.reload.direct_award?).to be true
          end
        end

        context 'when returning to review and generate' do
          before { put :update, params: { procurement_id: procurement.id, page: 'sending', return_to_review: 'Cancel, return to review your contract' } }

          it 'redirects to the contract details show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_contract_details_path
          end

          it 'updates the da_journey_state to review' do
            expect(procurement.reload.review?).to be true
          end
        end

        context 'when returning to results' do
          before { put :update, params: { procurement_id: procurement.id, page: 'sending', return_to_results: 'Return to results' } }

          it 'redirects to the procurement show page' do
            expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id)
          end

          it 'updates the aasm_state to results' do
            expect(procurement.reload.results?).to be true
          end
        end
      end
    end
  end

  describe '.delete_incomplete_contact_details' do
    before { procurement.update(da_journey_state: 'contract_details') }

    context 'when moving on and leaving invoicing contact details incomplete' do
      before do
        create(:facilities_management_rm3830_procurement_invoice_contact_detail_empty, procurement: procurement)
        procurement.update(using_buyer_detail_for_invoice_details: false)
      end

      context 'when on an edit page that is not new_invoicing_contact_details or new_invoicing_contact_details_address' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_authorised_representative' } }

        it 'does delete the invoice_contact_detail' do
          expect(procurement.reload.invoice_contact_detail.blank?).to be true
        end

        it 'resets the using_buyer_detail_for_invoice_details' do
          expect(procurement.reload.using_buyer_detail_for_invoice_details).to be_nil
        end
      end

      context 'when on invoicing_contact_details' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'invoicing_contact_details' } }

        it 'does delete the invoice_contact_detail' do
          expect(procurement.reload.invoice_contact_detail.blank?).to be true
        end

        it 'resets the using_buyer_detail_for_invoice_details' do
          expect(procurement.reload.using_buyer_detail_for_invoice_details).to be_nil
        end
      end

      context 'when on new_invoicing_contact_details' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_invoicing_contact_details' } }

        it 'does not delete the invoice_contact_detail' do
          expect(procurement.reload.invoice_contact_detail.blank?).to be false
        end

        it 'does not reset the using_buyer_detail_for_invoice_details' do
          expect(procurement.reload.using_buyer_detail_for_invoice_details).to be false
        end
      end

      context 'when on new_invoicing_contact_details_address' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_invoicing_contact_details_address' } }

        it 'does not delete the invoice_contact_detail' do
          expect(procurement.reload.invoice_contact_detail.blank?).to be false
        end

        it 'does not reset the using_buyer_detail_for_invoice_details' do
          expect(procurement.reload.using_buyer_detail_for_invoice_details).to be false
        end
      end

      context 'when on contract_details page' do
        before { get :show, params: { procurement_id: procurement.id } }

        it 'does delete the invoice_contact_detail' do
          expect(procurement.reload.invoice_contact_detail.blank?).to be true
        end

        it 'resets the using_buyer_detail_for_invoice_details' do
          expect(procurement.reload.using_buyer_detail_for_invoice_details).to be_nil
        end
      end
    end

    context 'when invoicing contact details are complete' do
      before do
        create(:facilities_management_rm3830_procurement_invoice_contact_detail, procurement: procurement)
        procurement.update(using_buyer_detail_for_invoice_details: false)
      end

      context 'when on an edit page that is not new_invoicing_contact_details or new_invoicing_contact_details_address' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_authorised_representative' } }

        it 'does not delete the invoice_contact_detail' do
          expect(procurement.reload.invoice_contact_detail.blank?).to be false
        end

        it 'does not reset the using_buyer_detail_for_invoice_details' do
          expect(procurement.reload.using_buyer_detail_for_invoice_details).to be false
        end
      end

      context 'when on contract_details page' do
        before { get :show, params: { procurement_id: procurement.id } }

        it 'does delete the invoice_contact_detail' do
          expect(procurement.reload.invoice_contact_detail.blank?).to be false
        end

        it 'does not reset the using_buyer_detail_for_invoice_details' do
          expect(procurement.reload.using_buyer_detail_for_invoice_details).to be false
        end
      end
    end

    context 'when moving on and leaving authorised representative details incomplete' do
      before do
        create(:facilities_management_rm3830_procurement_authorised_contact_detail_empty, procurement: procurement)
        procurement.update(using_buyer_detail_for_authorised_detail: false)
      end

      context 'when on an edit page that is not new_authorised_representative or new_authorised_representative_address' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_notices_contact_details' } }

        it 'does delete the authorised_contact_detail' do
          expect(procurement.reload.authorised_contact_detail.blank?).to be true
        end

        it 'resets the using_buyer_detail_for_authorised_detail' do
          expect(procurement.reload.using_buyer_detail_for_authorised_detail).to be_nil
        end
      end

      context 'when on authorised_representative' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'authorised_representative' } }

        it 'does delete the authorised_contact_detail' do
          expect(procurement.reload.authorised_contact_detail.blank?).to be true
        end

        it 'resets the using_buyer_detail_for_authorised_detail' do
          expect(procurement.reload.using_buyer_detail_for_authorised_detail).to be_nil
        end
      end

      context 'when on new_authorised_representative' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_authorised_representative' } }

        it 'does not delete the authorised_contact_detail' do
          expect(procurement.reload.authorised_contact_detail.blank?).to be false
        end

        it 'does not reset the using_buyer_detail_for_authorised_detail' do
          expect(procurement.reload.using_buyer_detail_for_authorised_detail).to be false
        end
      end

      context 'when on new_authorised_representative_address' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_authorised_representative_address' } }

        it 'does not delete the authorised_contact_detail' do
          expect(procurement.reload.authorised_contact_detail.blank?).to be false
        end

        it 'does not reset the using_buyer_detail_for_authorised_detail' do
          expect(procurement.reload.using_buyer_detail_for_authorised_detail).to be false
        end
      end

      context 'when on contract_details page' do
        before { get :show, params: { procurement_id: procurement.id } }

        it 'does delete the authorised_contact_detail' do
          expect(procurement.reload.authorised_contact_detail.blank?).to be true
        end

        it 'resets the using_buyer_detail_for_authorised_detail' do
          expect(procurement.reload.using_buyer_detail_for_authorised_detail).to be_nil
        end
      end
    end

    context 'when authorised representative details are complete' do
      before do
        create(:facilities_management_rm3830_procurement_authorised_contact_detail, procurement: procurement)
        procurement.update(using_buyer_detail_for_authorised_detail: false)
      end

      context 'when on an edit page that is not new_authorised_representative or new_authorised_representative_address' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_notices_contact_details' } }

        it 'does delete the authorised_contact_detail' do
          expect(procurement.reload.authorised_contact_detail.blank?).to be false
        end

        it 'does not reset the using_buyer_detail_for_authorised_detail' do
          expect(procurement.reload.using_buyer_detail_for_authorised_detail).to be false
        end
      end

      context 'when on contract_details page' do
        before { get :show, params: { procurement_id: procurement.id } }

        it 'does delete the authorised_contact_detail' do
          expect(procurement.reload.authorised_contact_detail.blank?).to be false
        end

        it 'does not reset the using_buyer_detail_for_authorised_detail' do
          expect(procurement.reload.using_buyer_detail_for_authorised_detail).to be false
        end
      end
    end

    context 'when moving on and leaving notices contact details incomplete' do
      before do
        create(:facilities_management_rm3830_procurement_notices_contact_detail_empty, procurement: procurement)
        procurement.update(using_buyer_detail_for_notices_detail: false)
      end

      context 'when on an edit page that is not new_notices_contact_details or new_notices_contact_details_address' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_invoicing_contact_details' } }

        it 'does delete the notices_contact_detail' do
          expect(procurement.reload.notices_contact_detail.blank?).to be true
        end

        it 'resets the using_buyer_detail_for_notices_detail' do
          expect(procurement.reload.using_buyer_detail_for_notices_detail).to be_nil
        end
      end

      context 'when on notices_contact_details' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'notices_contact_details' } }

        it 'does delete the notices_contact_detail' do
          expect(procurement.reload.notices_contact_detail.blank?).to be true
        end

        it 'resets the using_buyer_detail_for_notices_detail' do
          expect(procurement.reload.using_buyer_detail_for_notices_detail).to be_nil
        end
      end

      context 'when on new_notices_contact_details' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_notices_contact_details' } }

        it 'does not delete the notices_contact_detail' do
          expect(procurement.reload.notices_contact_detail.blank?).to be false
        end

        it 'does not reset the using_buyer_detail_for_notices_detail' do
          expect(procurement.reload.using_buyer_detail_for_notices_detail).to be false
        end
      end

      context 'when on new_notices_contact_details_address' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_notices_contact_details_address' } }

        it 'does not delete the notices_contact_detail' do
          expect(procurement.reload.notices_contact_detail.blank?).to be false
        end

        it 'does not reset the using_buyer_detail_for_notices_detail' do
          expect(procurement.reload.using_buyer_detail_for_notices_detail).to be false
        end
      end

      context 'when on contract_details page' do
        before { get :show, params: { procurement_id: procurement.id } }

        it 'does delete the notices_contact_detail' do
          expect(procurement.reload.notices_contact_detail.blank?).to be true
        end

        it 'resets the using_buyer_detail_for_notices_detail' do
          expect(procurement.reload.using_buyer_detail_for_notices_detail).to be_nil
        end
      end
    end

    context 'when notices contact details are complete' do
      before do
        create(:facilities_management_rm3830_procurement_notices_contact_detail, procurement: procurement)
        procurement.update(using_buyer_detail_for_notices_detail: false)
      end

      context 'when on an edit page that is not new_notices_contact_details or new_notices_contact_details_address' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_invoicing_contact_details' } }

        it 'does delete the notices_contact_detail' do
          expect(procurement.reload.notices_contact_detail.blank?).to be false
        end

        it 'does not reset the using_buyer_detail_for_notices_detail' do
          expect(procurement.reload.using_buyer_detail_for_notices_detail).to be false
        end
      end

      context 'when on contract_details page' do
        before { get :show, params: { procurement_id: procurement.id } }

        it 'does delete the notices_contact_detail' do
          expect(procurement.reload.notices_contact_detail.blank?).to be false
        end

        it 'does not reset the using_buyer_detail_for_notices_detail' do
          expect(procurement.reload.using_buyer_detail_for_notices_detail).to be false
        end
      end
    end
  end

  describe 'reset_security_policy_document_page' do
    before { procurement.update(da_journey_state: 'contract_details') }

    context 'when the security policy document file is blank but yes is selected' do
      before do
        procurement.update(security_policy_document_required: true)
        get :show, params: { procurement_id: procurement.id }
      end

      it 'sets security_policy_document_required to be nil' do
        expect(procurement.reload.security_policy_document_required).to be_nil
      end
    end
  end

  describe '.delete_incomplete_pension_data' do
    before { procurement.update(da_journey_state: 'contract_details') }

    context 'when moving on and leaving pension funds incomplete' do
      context 'when local_government_pension_scheme is false' do
        before do
          procurement.update(local_government_pension_scheme: false)
          get :show, params: { procurement_id: procurement.id }
        end

        it 'does not change local_government_pension_scheme' do
          expect(procurement.reload.local_government_pension_scheme).to be false
        end
      end

      context 'when local_government_pension_scheme is true' do
        before do
          procurement.update(local_government_pension_scheme: true)
          get :show, params: { procurement_id: procurement.id }
          procurement.reload
        end

        it 'does delete the pension funds' do
          expect(procurement.procurement_pension_funds.empty?).to be true
        end

        it 'does change local_government_pension_scheme' do
          expect(procurement.local_government_pension_scheme).to be_nil
        end
      end
    end

    context 'when the pension funds are saved' do
      context 'when the pension funds are not empty' do
        before do
          procurement.update(local_government_pension_scheme: true)
          create_list(:facilities_management_rm3830_procurement_pension_fund, 3, procurement: procurement)
          get :show, params: { procurement_id: procurement.id }
        end

        it 'does not delete the pension funds' do
          expect(procurement.procurement_pension_funds.empty?).to be false
        end

        it 'does not change local_government_pension_scheme' do
          expect(procurement.local_government_pension_scheme).to be true
        end
      end
    end
  end

  describe '.create_contact_detail' do
    before { procurement.update(da_journey_state: 'contract_details') }

    context 'when adding invoicing contact details' do
      let(:invoice_contact_detail) { create(:facilities_management_rm3830_procurement_invoice_contact_detail) }

      context 'when on new_invoicing_contact_details' do
        context 'when invoicing contact details do not exist' do
          before { get :edit, params: { procurement_id: procurement.id, page: 'new_invoicing_contact_details' } }

          it 'builds new invoicing contact details' do
            expect(assigns(:procurement).invoice_contact_detail.present?).to be true
          end
        end

        context 'when invoicing contact details already exist' do
          before do
            procurement.update(invoice_contact_detail: invoice_contact_detail)
            get :edit, params: { procurement_id: procurement.id, page: 'new_invoicing_contact_details' }
          end

          it 'does not build a new invoicing contact details' do
            expect(assigns(:procurement).invoice_contact_detail).to eq invoice_contact_detail
          end
        end
      end

      context 'when on new_invoicing_contact_details_address' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_invoicing_contact_details_address' } }

        it 'builds new invoicing contact details' do
          expect(assigns(:procurement).invoice_contact_detail.present?).to be true
        end
      end
    end

    context 'when adding authorised representative contact details' do
      let(:authorised_contact_detail) { create(:facilities_management_rm3830_procurement_authorised_contact_detail) }

      context 'when on new_authorised_representative' do
        context 'when authorised contact details do not exist' do
          before { get :edit, params: { procurement_id: procurement.id, page: 'new_authorised_representative' } }

          it 'builds new invoicing contact details' do
            expect(assigns(:procurement).authorised_contact_detail.present?).to be true
          end
        end

        context 'when invoicing contact details already exist' do
          before do
            procurement.update(authorised_contact_detail: authorised_contact_detail)
            get :edit, params: { procurement_id: procurement.id, page: 'new_invoicing_contact_details' }
          end

          it 'does not build a new invoicing contact details' do
            expect(assigns(:procurement).authorised_contact_detail).to eq authorised_contact_detail
          end
        end
      end

      context 'when on new_authorised_representative_address' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_authorised_representative_address' } }

        it 'builds new invoicing contact details' do
          expect(assigns(:procurement).authorised_contact_detail.present?).to be true
        end
      end
    end

    context 'when adding notice contact details' do
      let(:notices_contact_detail) { create(:facilities_management_rm3830_procurement_notices_contact_detail) }

      context 'when on new_notices_contact_details' do
        context 'when notices contact details do not exist' do
          before { get :edit, params: { procurement_id: procurement.id, page: 'new_notices_contact_details' } }

          it 'builds new notices contact details' do
            expect(assigns(:procurement).notices_contact_detail.present?).to be true
          end
        end

        context 'when notices contact details already exist' do
          before do
            procurement.update(notices_contact_detail: notices_contact_detail)
            get :edit, params: { procurement_id: procurement.id, page: 'new_notices_contact_details' }
          end

          it 'does not build a new notices contact details' do
            expect(assigns(:procurement).notices_contact_detail).to eq notices_contact_detail
          end
        end
      end

      context 'when on new_notices_contact_details_address' do
        before { get :edit, params: { procurement_id: procurement.id, page: 'new_notices_contact_details_address' } }

        it 'builds new notices contact details' do
          expect(assigns(:procurement).notices_contact_detail.present?).to be true
        end
      end
    end
  end

  describe '.create_first_pension_fund' do
    before { procurement.update(da_journey_state: 'contract_details') }

    context 'when no pension funds exist' do
      before { get :edit, params: { procurement_id: procurement.id, page: 'pension_funds' } }

      it 'creates a new pension fund' do
        expect(assigns(:procurement).procurement_pension_funds.size).to eq 1
      end
    end

    context 'when a pension fund does exist' do
      before do
        procurement.procurement_pension_funds.create
        get :edit, params: { procurement_id: procurement.id, page: 'pension_funds' }
      end

      it 'does not create a new pension fund' do
        expect(procurement.procurement_pension_funds.size).to eq 1
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
