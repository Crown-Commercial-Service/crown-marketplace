require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::Admin::LotDataController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM6378', supplier_id: supplier_framework.id } }

  let(:supplier_framework) { create(:supplier_framework, framework_id: 'RM6378') }
  let(:supplier_framework_lot) { create(:supplier_framework_lot, supplier_framework: supplier_framework, lot_id: "RM6378.#{lot_number}") }
  let(:supplier_framework_lot_services) { (1..5).map { |service_number| "RM6378.#{lot_number}.C#{service_number}" }.map { |service_id| create(:supplier_framework_lot_service, supplier_framework_lot:, service_id:) } }
  let(:supplier_framework_lot_jurisdictions) { %w[TLD3 TLD7 TLE2 TLH3 TLI4].map { |jurisdiction_id| create(:supplier_framework_lot_jurisdiction, supplier_framework_lot:, jurisdiction_id:) } }
  let(:lot_number) { '1a' }

  describe 'GET index' do
    context 'when not logged in' do
      it 'redirects to the sign-in' do
        get :index
        expect(response).to redirect_to facilities_management_rm6378_admin_new_user_session_path
      end
    end

    context 'when logged in as a buyer' do
      login_fm_buyer

      it 'redirects to not permitted' do
        get :index
        expect(response).to redirect_to '/facilities-management/RM6378/admin/not-permitted'
      end
    end

    context 'when logged in as an admin' do
      login_fm_admin

      before do
        supplier_framework_lot

        get :index
      end

      it 'renders the page' do
        expect(response).to render_template(:index)
      end

      it 'assigns framework' do
        expect(assigns(:framework).id).to eq('RM6378')
      end

      it 'assigns supplier_framework' do
        expect(assigns(:supplier_framework).id).to eq(supplier_framework.id)
      end

      # rubocop:disable RSpec/ExampleLength
      it 'assigns supplier_lot_data' do
        expect(assigns(:supplier_lot_data)).to eq(
          [
            {
              lot: { number: '1a', name: 'Total Facilities Management', number_as_slug: '1a' },
              enabled: true,
              sections: %i[services jurisdictions]
            },
            {
              lot: { number: '1b', name: 'Total Facilities Management', number_as_slug: '1b' },
              enabled: nil,
              sections: %i[services jurisdictions]
            },
            {
              lot: { number: '1c', name: 'Total Facilities Management', number_as_slug: '1c' },
              enabled: nil,
              sections: %i[services jurisdictions]
            },
            {
              lot: { number: '2a', name: 'Hard Facilities Management', number_as_slug: '2a' },
              enabled: nil,
              sections: %i[services jurisdictions]
            },
            {
              lot: { number: '2b', name: 'Hard Facilities Management', number_as_slug: '2b' },
              enabled: nil,
              sections: %i[services jurisdictions]
            },
            {
              lot: { number: '3a', name: 'Soft Facilities Management', number_as_slug: '3a' },
              enabled: nil,
              sections: %i[services jurisdictions]
            },
            {
              lot: { number: '3b', name: 'Soft Facilities Management', number_as_slug: '3b' },
              enabled: nil,
              sections: %i[services jurisdictions]
            },
            {
              lot: { number: '4a', name: 'Total Security Services', number_as_slug: '4a' },
              enabled: nil,
              sections: %i[services jurisdictions]
            },
            {
              lot: { number: '4b', name: 'Security Officer Services', number_as_slug: '4b' },
              enabled: nil,
              sections: %i[services jurisdictions]
            },
            {
              lot: { number: '4c', name: 'Electronic security systems and services', number_as_slug: '4c' },
              enabled: nil,
              sections: %i[services jurisdictions]
            },
            {
              lot: { number: '4d', name: 'Security advisory and assessment services', number_as_slug: '4d' },
              enabled: nil,
              sections: %i[services jurisdictions]
            },
          ]
        )
      end
      # rubocop:enable RSpec/ExampleLength
    end

    context 'and the framework dose not exist' do
      login_fm_admin

      it 'renders the unrecognised framework page with the right http status' do
        get :index, params: { framework: 'RM3826' }

        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET show' do
    login_fm_admin

    before do
      supplier_framework_lot_services
      supplier_framework_lot_jurisdictions

      get :show, params: { lot_number:, section: }
    end

    shared_examples 'when testing a section' do
      it 'renders the show template' do
        expect(response).to render_template(:show)
      end

      it 'assigns framework' do
        expect(assigns(:framework).id).to eq('RM6378')
      end

      it 'assigns supplier_framework' do
        expect(assigns(:supplier_framework).id).to eq(supplier_framework.id)
      end

      it 'assigns lot' do
        expect(assigns(:lot).id).to eq("RM6378.#{lot_number}")
      end

      it 'assigns supplier_framework_lot' do
        expect(assigns(:supplier_framework_lot).id).to eq(supplier_framework_lot.id)
      end

      context 'when considering the templates' do
        render_views

        it 'renders section partial template' do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(partial: "shared/admin/lot_data/show/_#{section}")
        end
      end
    end

    context 'and the section is services' do
      let(:section) { 'services' }

      include_context 'when testing a section'

      # rubocop:disable RSpec/ExampleLength
      it 'assigns services' do
        assigns(:services).zip(
          [
            ['Maintenance Services', 22],
            ['Statutory Compliance', 13],
            ['Landscaping / Horticultural Services', 8],
            ['Catering Services', 10],
            ['Cleaning Services', 12],
            ['Miscellaneous FM Services', 21],
            ['Visitor Support Services', 5],
            ['Waste Management', 7],
            ['Specialist FM Services', 5],
            ['Occupancy and Property Management Services', 14],
            ['Computer Aided Facilities Management (CAFM)', 1],
            ['Helpdesk Services', 1],
            ['Security Officer Services', 8],
          ]
        ).each do |(group, services), (expected_group, expected_number_of_services)|
          expect(group).to eq(expected_group)
          expect(services.length).to eq(expected_number_of_services)
        end
      end
      # rubocop:enable RSpec/ExampleLength

      it 'assigns supplier_framework_lot_service_ids' do
        assigned_supplier_framework_lot_service_ids = assigns(:supplier_framework_lot_service_ids)

        expect(assigned_supplier_framework_lot_service_ids.count).to eq(5)
        expect(assigned_supplier_framework_lot_service_ids).to eq(supplier_framework_lot_services.map(&:service_id))
      end
    end

    context 'and the section is jurisdictions' do
      let(:section) { 'jurisdictions' }

      include_context 'when testing a section'

      # rubocop:disable RSpec/ExampleLength
      it 'assigns jurisdictions' do
        assigns(:jurisdictions).zip(
          [
            ['North East (England)', 2],
            ['North West (England)', 5],
            ['Yorkshire & The Humber', 4],
            ['East Midlands (England)', 3],
            ['West Midlands (England)', 3],
            ['East (England)', 5],
            ['London', 5],
            ['South East (England)', 4],
            ['South West (England)', 5],
            ['Wales', 12],
            ['Scotland', 18],
            ['Northern Ireland', 11],
            ['National', 1],
            ['Overseas', 1],
          ]
        ).each do |(group, jurisdictions), (expected_group, expected_number_of_jurisdictions)|
          expect(group).to eq(expected_group)
          expect(jurisdictions.length).to eq(expected_number_of_jurisdictions)
        end
      end
      # rubocop:enable RSpec/ExampleLength

      it 'assigns supplier_framework_lot_jurisdiction_ids' do
        assigned_supplier_framework_lot_jurisdiction_ids = assigns(:supplier_framework_lot_jurisdiction_ids)

        expect(assigned_supplier_framework_lot_jurisdiction_ids.count).to eq(5)
        expect(assigned_supplier_framework_lot_jurisdiction_ids).to eq(supplier_framework_lot_jurisdictions.map(&:jurisdiction_id))
      end
    end

    context 'when the section is unexpected' do
      let(:section) { :something_else }

      it 'redirects to the index page' do
        expect(response).to redirect_to(facilities_management_rm6378_admin_supplier_lot_data_path)
      end
    end
  end

  describe 'GET edit' do
    login_fm_admin

    before do
      supplier_framework_lot_services
      supplier_framework_lot_jurisdictions

      get :edit, params: { lot_number:, section: }
    end

    shared_examples 'when testing a section' do
      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end

      it 'assigns framework' do
        expect(assigns(:framework).id).to eq('RM6378')
      end

      it 'assigns supplier_framework' do
        expect(assigns(:supplier_framework).id).to eq(supplier_framework.id)
      end

      it 'assigns lot' do
        expect(assigns(:lot).id).to eq("RM6378.#{lot_number}")
      end

      it 'assigns supplier_framework_lot' do
        expect(assigns(:supplier_framework_lot).id).to eq(supplier_framework_lot.id)
      end

      it 'assigns model' do
        expect(assigns(:model).class).to be(Supplier::Framework::Lot)
      end

      context 'when considering the templates' do
        render_views

        it 'renders section partial template' do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(partial: "shared/admin/lot_data/edit/_#{section}")
        end
      end
    end

    context 'and the section is lot_status' do
      let(:section) { 'lot_status' }

      include_context 'when testing a section'
    end

    context 'and the section is services' do
      let(:section) { 'services' }

      include_context 'when testing a section'

      it 'assigns supplier_framework_lot_service_ids' do
        expect(assigns(:supplier_framework_lot_service_ids)).to eq(supplier_framework_lot_services.map(&:service_id))
      end
    end

    context 'and the section is jurisdictions' do
      let(:section) { 'jurisdictions' }

      include_context 'when testing a section'

      it 'assigns supplier_framework_lot_jurisdiction_ids' do
        expect(assigns(:supplier_framework_lot_jurisdiction_ids)).to eq(supplier_framework_lot_jurisdictions.map(&:jurisdiction_id))
      end
    end

    context 'when the section is unexpected' do
      let(:section) { :something_else }

      it 'redirects to the show page' do
        expect(response).to redirect_to(facilities_management_rm6378_admin_supplier_lot_datum_path(section:))
      end
    end
  end

  describe 'GET update' do
    let(:change_log) { ChangeLog.find_by(user_id: controller.current_user.id, framework_id: 'RM6378') }

    login_fm_admin

    before do
      supplier_framework_lot_services
      supplier_framework_lot_jurisdictions

      get :update, params: { lot_number: lot_number, section: section, supplier_framework_lot: model_params }
    end

    shared_examples 'when testing a section' do
      it 'assigns framework' do
        expect(assigns(:framework).id).to eq('RM6378')
      end

      it 'assigns supplier_framework' do
        expect(assigns(:supplier_framework).id).to eq(supplier_framework.id)
      end

      it 'assigns lot' do
        expect(assigns(:lot).id).to eq("RM6378.#{lot_number}")
      end

      it 'assigns supplier_framework_lot' do
        expect(assigns(:supplier_framework_lot).id).to eq(supplier_framework_lot.id)
      end

      it 'assigns model' do
        expect(assigns(:model).class).to be(Supplier::Framework::Lot)
      end
    end

    context 'and the section is lot_status' do
      let(:section) { 'lot_status' }
      let(:model_params) { { enabled: 'false' } }

      include_context 'when testing a section'

      context 'when it is valid' do
        it 'redirects to the index page' do
          expect(response).to redirect_to(facilities_management_rm6378_admin_supplier_lot_data_path)
        end

        it 'updates the details' do
          expect(supplier_framework_lot.reload.enabled).to be(false)
        end

        it 'creates a change log' do
          expect(change_log.change_type).to eq('update_supplier_framework_lot_status')
          expect(change_log.change_data['id']).to eq(supplier_framework_lot.id)
          expect(change_log.change_data['after']).to eq({ 'enabled' => false })
        end
      end

      context 'when it is invalid' do
        let(:model_params) { { enabled: nil } }

        render_views

        it 'has errors on the model' do
          expect(assigns(:model).errors).to be_present
        end

        it 'renders section partial template' do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(partial: "shared/admin/lot_data/edit/_#{section}")
        end

        it 'does not create a change log' do
          expect(change_log).to be_nil
        end
      end
    end

    context 'and the section is services' do
      let(:section) { 'services' }
      let(:service_ids) { [1, 2, 3, 6, 7].map { |service_number| "RM6378.#{lot_number}.C#{service_number}" } }
      let(:model_params) { { service_ids: } }

      include_context 'when testing a section'

      it 'assigns supplier_framework_lot_service_ids' do
        expect(assigns(:supplier_framework_lot_service_ids)).to eq(supplier_framework_lot_services.map(&:service_id))
      end

      context 'when it is valid' do
        it 'redirects to the show page' do
          expect(response).to redirect_to(facilities_management_rm6378_admin_supplier_lot_datum_path(section:))
        end

        it 'updates the details' do
          expect(supplier_framework_lot.reload.services.pluck(:service_id)).to eq(service_ids)
        end

        # rubocop:disable RSpec/MultipleExpectations
        it 'creates a change log' do
          expect(change_log.change_type).to eq('update_supplier_framework_lot_services')
          expect(change_log.change_data['id']).to eq(supplier_framework_lot.id)
          expect(change_log.change_data['added']).to eq(['RM6378.1a.C6', 'RM6378.1a.C7'])
          expect(change_log.change_data['removed']).to eq(['RM6378.1a.C4', 'RM6378.1a.C5'])
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context 'when it is invalid' do
        let(:model_params) { { service_ids: ['Invalid ID'] } }

        render_views

        it 'has errors on the model' do
          expect(assigns(:model).errors).to be_present
        end

        it 'renders section partial template' do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(partial: "shared/admin/lot_data/edit/_#{section}")
        end

        it 'does not create a change log' do
          expect(change_log).to be_nil
        end
      end
    end

    context 'and the section is jurisdictions' do
      let(:section) { 'jurisdictions' }
      let(:jurisdiction_ids) { %w[TLD1 TLD7 TLE1 TLH3 TLI4] }
      let(:model_params) { { jurisdiction_ids: } }

      include_context 'when testing a section'

      it 'assigns supplier_framework_lot_jurisdiction_ids' do
        expect(assigns(:supplier_framework_lot_jurisdiction_ids)).to eq(supplier_framework_lot_jurisdictions.map(&:jurisdiction_id))
      end

      context 'when it is valid' do
        it 'redirects to the show page' do
          expect(response).to redirect_to(facilities_management_rm6378_admin_supplier_lot_datum_path(section:))
        end

        it 'updates the details' do
          expect(supplier_framework_lot.reload.jurisdictions.pluck(:jurisdiction_id).sort).to eq(jurisdiction_ids)
        end

        # rubocop:disable RSpec/MultipleExpectations
        it 'creates a change log' do
          expect(change_log.change_type).to eq('update_supplier_framework_lot_jurisdictions')
          expect(change_log.change_data['id']).to eq(supplier_framework_lot.id)
          expect(change_log.change_data['added']).to eq(['TLD1', 'TLE1'])
          expect(change_log.change_data['removed']).to eq(['TLD3', 'TLE2'])
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context 'when it is invalid' do
        let(:model_params) { { jurisdiction_ids: ['Invalid ID'] } }

        render_views

        it 'has errors on the model' do
          expect(assigns(:model).errors).to be_present
        end

        it 'renders section partial template' do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(partial: "shared/admin/lot_data/edit/_#{section}")
        end

        it 'does not create a change log' do
          expect(change_log).to be_nil
        end
      end
    end

    context 'when the section is unexpected' do
      let(:section) { :something_else }
      let(:model_params) { { enabled: 'false' } }

      it 'redirects to the show page' do
        expect(response).to redirect_to(facilities_management_rm6378_admin_supplier_lot_datum_path(section:))
      end
    end
  end
end
