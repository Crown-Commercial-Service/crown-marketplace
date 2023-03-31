require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementDetailsController do
  let(:default_params) { { service: 'facilities_management', framework: 'RM3830' } }
  let(:procurement) { create(:facilities_management_rm3830_procurement_entering_requirements, user:) }
  let(:user) { controller.current_user }

  login_fm_buyer_with_details

  context 'without buyer details' do
    login_fm_buyer

    it 'will redirect to buyer details' do
      get :show, params: { procurement_id: procurement.id, section: 'contract-name' }

      expect(response).to redirect_to edit_facilities_management_buyer_detail_path(id: controller.current_user.buyer_detail.id)
    end
  end

  describe 'GET show' do
    let(:procurement_options) { {} }

    before do
      procurement.update(procurement_options)
      get :show, params: { procurement_id: procurement.id, section: section_name }
    end

    context 'when the show page is not recognised' do
      let(:section_name) { 'contract_name' }

      it 'redirects to the procurement show page' do
        expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
      end
    end

    context 'when the user does not own the procurement' do
      let(:section_name) { 'contract-period' }
      let(:user) { create(:user) }

      it 'redirects to the not permitted path' do
        expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
      end
    end

    context 'when the user wants to edit contract-periods' do
      let(:section_name) { 'contract-period' }

      context 'when the contract periods are not started' do
        let(:procurement_options) { { initial_call_off_period_years: nil, initial_call_off_period_months: nil, initial_call_off_start_date: nil, mobilisation_period_required: nil, extensions_required: nil } }

        it 'redirects to the edit page with contract-period section' do
          expect(response).to redirect_to edit_facilities_management_rm3830_procurement_procurement_detail_path(procurement, section: section_name)
        end
      end

      context 'when the contract periods are not complete' do
        let(:procurement_options) { { initial_call_off_period_months: nil, mobilisation_period_required: false, extensions_required: false } }

        it 'redirects to the edit page with the contract-period section' do
          expect(response).to redirect_to edit_facilities_management_rm3830_procurement_procurement_detail_path(procurement, section: section_name)
        end
      end

      context 'when the contract periods are complete' do
        let(:procurement_options) { { initial_call_off_start_date: 6.months.from_now, initial_call_off_period_years: 1, initial_call_off_period_months: 0, mobilisation_period_required: false, extensions_required: false } }

        render_views

        it 'renders the contract_periods partial' do
          expect(response).to render_template(partial: '_contract_period')
        end

        it 'sets the procurement' do
          expect(assigns(:procurement)).to eq procurement
        end
      end
    end

    context 'when the user wants to edit services' do
      let(:section_name) { 'services' }
      let(:procurement_options) { { service_codes: } }

      context 'when the services are not complete' do
        let(:service_codes) { [] }

        it 'redirects to the edit page with the services section' do
          expect(response).to redirect_to edit_facilities_management_rm3830_procurement_procurement_detail_path(procurement, section: section_name)
        end
      end

      context 'when the services are complete' do
        let(:service_codes) { ['E.1'] }

        render_views

        it 'renders the services partial' do
          expect(response).to render_template(partial: '_services')
        end

        it 'sets the procurement' do
          expect(assigns(:procurement)).to eq procurement
        end
      end
    end

    context 'when the user wants to edit buildings' do
      let(:section_name) { 'buildings' }

      context 'when there are no active_procurement_buildings' do
        it 'redirects to the edit page with the buildings section' do
          expect(response).to redirect_to edit_facilities_management_rm3830_procurement_procurement_detail_path(procurement, section: section_name)
        end
      end

      context 'when there are active_procurement_buildings' do
        let(:building) { create(:facilities_management_building, user:) }
        let(:procurement_options) { { procurement_buildings_attributes: { '0': { building_id: building.id, active: true } } } }

        render_views

        it 'renders the contract_periods partial' do
          expect(response).to render_template(partial: '_buildings')
        end

        it 'sets the procurement' do
          expect(assigns(:procurement)).to eq procurement
        end

        it 'sets the active procurement buildings' do
          expect(assigns(:active_procurement_buildings).count).to eq 1
          expect(assigns(:active_procurement_buildings).class.to_s).to eq 'FacilitiesManagement::RM3830::ProcurementBuilding::ActiveRecord_AssociationRelation'
        end
      end
    end

    context 'when the user wants to assign services to buildings' do
      let(:section_name) { 'buildings-and-services' }
      let(:building) { create(:facilities_management_building, user:) }
      let(:procurement_options) { { procurement_buildings_attributes: { '0': { building_id: building.id, active: true } } } }

      render_views

      it 'renders the buildings_and_services partial' do
        expect(response).to render_template(partial: '_buildings_and_services')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end

      it 'sets the active procurement buildings' do
        expect(assigns(:active_procurement_buildings).count).to eq 1
        expect(assigns(:active_procurement_buildings).class.to_s).to eq 'FacilitiesManagement::RM3830::ProcurementBuilding::ActiveRecord_AssociationRelation'
      end
    end

    context 'when the user wants to view the service requirements' do
      let(:section_name) { 'service-requirements' }
      let(:building) { create(:facilities_management_building, user:) }
      let(:procurement_options) { { procurement_buildings_attributes: { '0': { building_id: building.id, active: true, service_codes: %w[E.1 E.2] } } } }

      render_views

      it 'renders the service_requirements partial' do
        expect(response).to render_template(partial: '_service_requirements')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end

      it 'sets the active procurement buildings' do
        expect(assigns(:active_procurement_buildings).count).to eq 1
        expect(assigns(:active_procurement_buildings).class.to_s).to eq 'FacilitiesManagement::RM3830::ProcurementBuilding::ActiveRecord_AssociationRelation'
      end
    end
  end

  describe 'GET edit' do
    before { get :edit, params: { procurement_id: procurement.id, section: section_name } }

    context 'when the edit page is not recognised' do
      let(:section_name) { 'services-and-buildings' }

      it 'redirects to the procurement show page' do
        expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
      end
    end

    context 'when the user does not own the procurement' do
      let(:section_name) { 'services-and-buildings' }
      let(:user) { create(:user) }

      it 'redirects to the not permitted path' do
        expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
      end
    end

    context 'when the user wants to edit the contract name' do
      let(:section_name) { 'contract-name' }

      render_views

      it 'renders the contract_name partial' do
        expect(response).to render_template(partial: '_contract_name')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end
    end

    context 'when the user wants to edit the estimated annual cost' do
      let(:section_name) { 'estimated-annual-cost' }

      render_views

      it 'renders the estimated_annual_cost partial' do
        expect(response).to render_template(partial: '_estimated_annual_cost')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end
    end

    context 'when the user wants to edit tupe' do
      let(:section_name) { 'tupe' }

      render_views

      it 'renders the tupe partial' do
        expect(response).to render_template(partial: '_tupe')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end
    end

    context 'when the user wants to edit the contract period' do
      let(:section_name) { 'contract-period' }

      render_views

      it 'renders the contract_period partial' do
        expect(response).to render_template(partial: '_contract_period')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end

      it 'builds the call off extensions' do
        expect(assigns(:procurement).call_off_extensions.length).to eq 4
        expect(assigns(:procurement).call_off_extensions.map(&:id).all?(&:nil?)).to be true
        expect(assigns(:procurement).call_off_extensions.map(&:facilities_management_rm3830_procurement_id).all? { |id| id == procurement.id }).to be true
      end

      context 'when the procurement already has extensions' do
        let(:procurement) { create(:facilities_management_rm3830_procurement_with_extension_periods, user:) }

        it 'finds the extensions' do
          expect(assigns(:procurement).call_off_extensions.length).to eq 4
          expect(assigns(:procurement).call_off_extensions.map(&:id).none?(&:nil?)).to be true
          expect(assigns(:procurement).call_off_extensions.map(&:facilities_management_rm3830_procurement_id).all? { |id| id == procurement.id }).to be true
        end
      end
    end

    context 'when the user wants to edit the services' do
      let(:section_name) { 'services' }

      render_views

      it 'renders the services partial' do
        expect(response).to render_template(partial: '_services')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end
    end

    context 'when the user wants to edit the buildings' do
      let(:section_name) { 'buildings' }

      render_views

      it 'renders the buildings partial' do
        expect(response).to render_template(partial: '_buildings')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end

      # rubocop:disable RSpec/NestedGroups
      context 'and the user has buildings' do
        let(:first_building) { user.buildings.find_by(building_name: 'aa') }
        let(:last_building) { user.buildings.find_by(building_name: 'af') }

        before do
          allow(FacilitiesManagement::Building).to receive(:default_per_page).and_return(5)

          ('aa'..'af').each { |building_name| create(:facilities_management_building, user:, building_name:) }
        end

        context 'and none are active' do
          before { get :edit, params: { procurement_id: procurement.id, section: section_name } }

          it 'sets building_params and it is empty' do
            expect(assigns(:building_params)).to be_empty
          end

          it 'sets buildings' do
            expect(assigns(:buildings).length).to eq 5
            expect(assigns(:buildings).class.to_s).to eq 'FacilitiesManagement::Building::ActiveRecord_AssociationRelation'
          end

          it 'sets hidden_buildings and it is empty' do
            expect(assigns(:hidden_buildings)).to be_empty
          end
        end

        context 'and some are active' do
          before do
            create(:facilities_management_rm3830_procurement_building_no_services, procurement: procurement, building: first_building, active: true)
            get :edit, params: { procurement_id: procurement.id, section: section_name }
          end

          it 'sets building_params' do
            expect(assigns(:building_params)).to eq({ first_building.id => '1' })
          end

          it 'sets buildings' do
            expect(assigns(:buildings).length).to eq 5
            expect(assigns(:buildings).class.to_s).to eq 'FacilitiesManagement::Building::ActiveRecord_AssociationRelation'
          end

          it 'sets hidden_buildings and it is empty' do
            expect(assigns(:hidden_buildings)).to be_empty
          end
        end

        context 'and some are active on the next page' do
          before do
            create(:facilities_management_rm3830_procurement_building_no_services, procurement: procurement, building: first_building, active: true)
            create(:facilities_management_rm3830_procurement_building_no_services, procurement: procurement, building: last_building, active: true)
            get :edit, params: { procurement_id: procurement.id, section: section_name }
          end

          it 'sets building_params' do
            expect(assigns(:building_params)).to eq({ first_building.id => '1', last_building.id => '1' })
          end

          it 'sets buildings' do
            expect(assigns(:buildings).length).to eq 5
            expect(assigns(:buildings).class.to_s).to eq 'FacilitiesManagement::Building::ActiveRecord_AssociationRelation'
          end

          it 'sets hidden_buildings' do
            expect(assigns(:hidden_buildings).class.to_s).to eq 'FacilitiesManagement::Building::ActiveRecord_AssociationRelation'
            expect(assigns(:hidden_buildings)).to eq([last_building])
          end
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end

  describe 'PUT update' do
    before { put :update, params: { procurement_id: procurement.id, section: section_name, facilities_management_rm3830_procurement: update_params, commit: 'Save and return' } }

    context 'when updating the contract name' do
      let(:section_name) { 'contract-name' }

      context 'and the data is valid' do
        let(:update_params) { { contract_name: 'Hello there' } }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
        end

        it 'updates the contract name' do
          expect { procurement.reload }.to change(procurement, :contract_name)

          expect(procurement.contract_name).to eq('Hello there')
        end
      end

      context 'and the data is not valid' do
        let(:update_params) { { contract_name: nil } }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'does not update the contract name' do
          expect { procurement.reload }.not_to change(procurement, :contract_name)
        end
      end

      context 'and an unpermitted parameters are passed in' do
        let(:update_params) { { estimated_annual_cost: 87_654 } }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
        end

        it 'does no update the unpermitted attribute' do
          expect { procurement.reload }.not_to change(procurement, :estimated_annual_cost)
        end
      end
    end

    context 'when updating the estimated annual cost' do
      let(:section_name) { 'estimated-annual-cost' }

      context 'and the data is valid' do
        let(:update_params) { { estimated_cost_known: true, estimated_annual_cost: 456_789 } }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
        end

        it 'updates the estimated annual cost' do
          expect { procurement.reload }.to(
            change(procurement, :estimated_cost_known).to(true)
            .and(change(procurement, :estimated_annual_cost).to(456_789))
          )
        end
      end

      context 'and the data is not valid' do
        let(:update_params) { { estimated_cost_known: true, estimated_annual_cost: nil } }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'does not update the estimated annual cost' do
          RSpec::Matchers.define_negated_matcher :not_change, :change

          expect do
            procurement.reload
          end.to(
            not_change(procurement, :estimated_cost_known)
            .and(not_change(procurement, :estimated_annual_cost))
          )
        end
      end

      context 'and an unpermitted parameters are passed in' do
        let(:update_params) { { contract_name: 'Hello there', estimated_cost_known: false } }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
        end

        it 'does no update the unpermitted attribute' do
          expect { procurement.reload }.not_to change(procurement, :contract_name)
        end
      end
    end

    context 'when updating tupe' do
      let(:section_name) { 'tupe' }

      context 'and the data is valid' do
        let(:update_params) { { tupe: true } }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
        end

        it 'updates tupe' do
          expect { procurement.reload }.to change(procurement, :tupe)

          expect(procurement.tupe).to be true
        end
      end

      context 'and the data is not valid' do
        let(:update_params) { { tupe: nil } }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'does not update tupe' do
          expect { procurement.reload }.not_to change(procurement, :tupe)
        end
      end

      context 'and an unpermitted parameters are passed in' do
        let(:update_params) { { contract_name: 'Hello there', tupe: false } }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
        end

        it 'does no update the unpermitted attribute' do
          expect { procurement.reload }.not_to change(procurement, :contract_name)
        end
      end
    end

    context 'when updating contract period' do
      let(:section_name) { 'contract-period' }

      context 'and the data is valid' do
        let(:start_date) { Time.now.in_time_zone('London') + 1.year }
        let(:update_params) do
          {
            initial_call_off_start_date_dd: start_date.day,
            initial_call_off_start_date_mm: start_date.month,
            initial_call_off_start_date_yyyy: start_date.year,
            initial_call_off_period_years: 2,
            initial_call_off_period_months: 6,
            mobilisation_period_required: false,
            mobilisation_period: nil,
            extensions_required: true,
            call_off_extensions_attributes: {
              '0': {
                extension: 0,
                years: 1,
                months: 0,
                extension_required: true
              },
              '1': {
                extension: 1,
                years: nil,
                months: nil,
                extension_required: false
              },
              '2': {
                extension: 2,
                years: nil,
                months: nil,
                extension_required: false
              },
              '3': {
                extension: 3,
                years: nil,
                months: nil,
                extension_required: false
              }
            }
          }
        end

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_procurement_detail_path(procurement, 'contract-period')
        end

        # rubocop:disable RSpec/ExampleLength
        it 'updates the contract period' do
          expect do
            procurement.reload
          end.to(
            change(procurement, :initial_call_off_start_date).to(start_date.to_date)
            .and(change(procurement, :initial_call_off_period_years).to(2))
            .and(change(procurement, :initial_call_off_period_months).to(6))
            .and(change(procurement, :extensions_required).to(true))
            .and(change(procurement, :call_off_extensions))
          )

          expect(procurement.call_off_extensions.count).to eq 1
          expect(procurement.call_off_extensions.first.attributes.slice(
                   'facilities_management_rm3830_procurement_id',
                   'extension',
                   'years',
                   'months'
                 )).to eq(
                   {
                     'facilities_management_rm3830_procurement_id' => procurement.id,
                     'extension' => 0,
                     'years' => 1,
                     'months' => 0
                   }
                 )
        end
        # rubocop:enable RSpec/ExampleLength
      end

      context 'and the data is not valid' do
        let(:update_params) do
          {
            initial_call_off_start_date_dd: nil,
            initial_call_off_start_date_mm: nil,
            initial_call_off_start_date_yyyy: nil,
            initial_call_off_period_years: 2,
            initial_call_off_period_months: 6,
            mobilisation_period_required: false,
            mobilisation_period: nil,
            extensions_required: true,
            call_off_extensions_attributes: {
              '0': {
                extension: 0,
                years: 1,
                months: 0,
                extension_required: true
              },
              '1': {
                extension: 1,
                years: nil,
                months: nil,
                extension_required: false
              },
              '2': {
                extension: 2,
                years: nil,
                months: nil,
                extension_required: false
              },
              '3': {
                extension: 3,
                years: nil,
                months: nil,
                extension_required: false
              }
            }
          }
        end

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'does not update the contract periods' do
          RSpec::Matchers.define_negated_matcher :not_change, :change

          expect do
            procurement.reload
          end.to(
            not_change(procurement, :initial_call_off_start_date)
            .and(not_change(procurement, :initial_call_off_period_years))
            .and(not_change(procurement, :initial_call_off_period_months))
            .and(not_change(procurement, :extensions_required))
            .and(not_change { procurement.call_off_extensions.count })
          )
        end
      end

      context 'and an unpermitted parameters are passed in' do
        let(:start_date) { Time.now.in_time_zone('London') + 1.year }
        let(:update_params) { { contract_name: 'Hello there', initial_call_off_start_date_dd: start_date.day, initial_call_off_start_date_mm: start_date.month, initial_call_off_start_date_yyyy: start_date.year, initial_call_off_period_years: 2, initial_call_off_period_months: 6, mobilisation_period_required: false, extensions_required: false } }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_procurement_detail_path(procurement, 'contract-period')
        end

        it 'does no update the unpermitted attribute' do
          expect { procurement.reload }.not_to change(procurement, :contract_name)
        end
      end
    end

    context 'when updating services' do
      let(:section_name) { 'services' }

      context 'and the data is valid' do
        let(:update_params) { { service_codes: %w[F.1 F.2] } }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_procurement_detail_path(procurement, 'services')
        end

        it 'updates service_codes' do
          expect { procurement.reload }.to change(procurement, :service_codes)

          expect(procurement.service_codes).to eq %w[F.1 F.2]
        end
      end

      context 'and the data is not valid' do
        let(:update_params) { { service_codes: %w[] } }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'does not update service_codes' do
          expect { procurement.reload }.not_to change(procurement, :service_codes)
        end
      end

      context 'and an unpermitted parameters are passed in' do
        let(:update_params) { { contract_name: 'Hello there', service_codes: %w[C.1] } }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_procurement_detail_path(procurement, 'services')
        end

        it 'does no update the unpermitted attribute' do
          expect { procurement.reload }.not_to change(procurement, :contract_name)
        end
      end
    end

    context 'when updating buildings' do
      let(:section_name) { 'buildings' }
      let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, user:) }
      let(:building) { procurement.procurement_buildings.first.building }
      let(:new_building) { create(:facilities_management_building, user:) }

      context 'and the data is valid' do
        let(:update_params) { { procurement_buildings_attributes: { '0': { active: '1', building_id: building.id }, '2': { active: '1', building_id: new_building.id } } } }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_procurement_detail_path(procurement, 'buildings')
        end

        it 'updates procurement_buildings' do
          expect { procurement.reload }.to change(procurement, :procurement_buildings).and(change { procurement.procurement_buildings.length }.to(2))
          expect(
            procurement.procurement_buildings.order(:created_at).pluck(:facilities_management_rm3830_procurement_id, :building_id, :active).sort
          ).to eq(
            [
              [procurement.id, building.id, true],
              [procurement.id, new_building.id, true],
            ].sort
          )
        end
      end

      context 'and the data is not valid' do
        let(:update_params) { { procurement_buildings_attributes: { '0': { active: '0', building_id: building.id }, '2': { active: '0', building_id: new_building.id } } } }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'does not update procurement buildings' do
          expect { procurement.reload }.not_to change { procurement.procurement_buildings.length }.from(1)
        end

        it 'sets building_params' do
          expect(assigns(:building_params)).to eq({ building.id => '0' })
        end

        it 'sets buildings' do
          expect(assigns(:buildings).length).to eq 1
          expect(assigns(:buildings).class.to_s).to eq 'FacilitiesManagement::Building::ActiveRecord_AssociationRelation'
        end

        it 'sets hidden_buildings and it is empty' do
          expect(assigns(:hidden_buildings)).to be_empty
        end
      end

      context 'and an unpermitted parameters are passed in' do
        let(:update_params) { { contract_name: 'Hello there' } }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_procurement_detail_path(procurement, 'buildings')
        end

        it 'does no update the unpermitted attribute' do
          expect { procurement.reload }.not_to change(procurement, :contract_name)
        end
      end
    end
  end

  describe 'paginating the buildings page' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_entering_requirements_with_buildings, user:) }

    let(:building1) { create(:facilities_management_building, user: procurement.user, building_name: 'Building 1') }
    let(:building2) { create(:facilities_management_building, user: procurement.user, building_name: 'Building 2') }
    let(:building3) { create(:facilities_management_building, user: procurement.user, building_name: 'Building 3') }
    let(:building4) { create(:facilities_management_building, user: procurement.user, building_name: 'Building 4') }

    let(:building1_active) { '1' }
    let(:building2_active) { '0' }
    let(:building3_active) { '0' }
    let(:building4_active) { '0' }

    before do
      procurement.procurement_buildings.first.update(building_id: building1.id)
      procurement.procurement_buildings.second.update(building_id: building2.id, active: false)
      put :update, params: { procurement_id: procurement.id, section: 'buildings', page: '1', 'paginate-2': '2', facilities_management_rm3830_procurement: { procurement_buildings_attributes: { '0': { building_id: building1.id, active: building1_active }, '1': { building_id: building2.id, active: building2_active }, '2': { building_id: building3.id, active: building3_active }, '3': { building_id: building4.id, active: building4_active } } } }
    end

    context 'when a building as checked' do
      let(:building2_active) { '1' }

      it 'adds to the building_params' do
        expect(assigns(:building_params).keys).to include building1.id
        expect(assigns(:building_params).keys).to include building2.id
        expect(assigns(:building_params).size).to eq 2
      end

      it 'adds to the hidden_procurement_buildings' do
        hidden_building_ids = assigns(:hidden_buildings).map(&:id)
        expect(hidden_building_ids).to include building1.id
        expect(hidden_building_ids).to include building2.id
      end

      it 'updates the page param' do
        expect(controller.params[:page]).to eq '2'
      end

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end
    end

    context 'when a building is un-checked' do
      let(:building1_active) { '0' }

      it 'updates the building_params' do
        expect(assigns(:building_params)[building1.id]).to eq '0'
      end

      it 'does not change hidden_procurement_buildings' do
        hidden_building_ids = assigns(:hidden_buildings).map(&:id)
        expect(hidden_building_ids).to eq [building1.id]
      end

      it 'updates the page param' do
        expect(controller.params[:page]).to eq '2'
      end

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end
    end

    context 'when no buildings are checked' do
      it 'does not change the building_params' do
        expect(assigns(:building_params).keys).to eq [building1.id]
        expect(assigns(:building_params)[building1.id]).to eq '1'
      end

      it 'does not change hidden_procurement_buildings' do
        hidden_building_ids = assigns(:hidden_buildings).map(&:id)
        expect(hidden_building_ids).to eq [building1.id]
      end

      it 'updates the page param' do
        expect(controller.params[:page]).to eq '2'
      end

      it 'renders the edit page' do
        expect(response).to render_template :edit
      end
    end
  end
end
