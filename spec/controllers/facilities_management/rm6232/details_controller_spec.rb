require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::DetailsController, type: :controller do
  let(:default_params) { { service: 'facilities_management', framework: 'RM6232' } }
  let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, user: user) }
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
      procurement.update(**procurement_options)
      get :show, params: { procurement_id: procurement.id, section: section_name }
    end

    context 'when the show page is not recognised' do
      let(:section_name) { 'contract_name' }

      it 'redirects to the procurement show page' do
        expect(response).to redirect_to facilities_management_rm6232_procurement_path(procurement)
      end
    end

    context 'when the user does not own the procurement' do
      let(:section_name) { 'contract-period' }
      let(:user) { create(:user) }

      it 'redirects to the not permitted path' do
        expect(response).to redirect_to facilities_management_rm6232_not_permitted_path
      end
    end

    context 'when the user wants to edit contract-periods' do
      let(:section_name) { 'contract-period' }

      context 'when the contract periods are not started' do
        let(:procurement_options) { { initial_call_off_period_years: nil, initial_call_off_period_months: nil, initial_call_off_start_date: nil, mobilisation_period_required: nil, extensions_required: nil } }

        it 'redirects to the edit page with contract-period section' do
          expect(response).to redirect_to edit_facilities_management_rm6232_procurement_detail_path(procurement, section: section_name)
        end
      end

      context 'when the contract periods are not complete' do
        let(:procurement_options) { { initial_call_off_period_months: nil, mobilisation_period_required: false, extensions_required: false } }

        it 'redirects to the edit page with the contract-period section' do
          expect(response).to redirect_to edit_facilities_management_rm6232_procurement_detail_path(procurement, section: section_name)
        end
      end

      context 'when the contract periods are complete' do
        let(:procurement_options) { {} }

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
      let(:procurement_options) { { service_codes: service_codes } }

      context 'when the services are not complete' do
        let(:service_codes) { [] }

        pending 'redirects to the edit page with the services section' do
          expect(response).to redirect_to edit_facilities_management_rm6232_procurement_detail_path(procurement, section: section_name)
        end
      end

      context 'when the services are complete' do
        let(:service_codes) { ['E.1'] }

        render_views

        pending 'renders the services partial' do
          expect(response).to render_template(partial: '_services')
        end

        it 'sets the procurement' do
          expect(assigns(:procurement)).to eq procurement
        end
      end
    end

    context 'when the user wants to edit buildings' do
      let(:section_name) { 'buildings' }

      before do
        procurement.active_procurement_buildings.each { |pb| pb.update(active: false) } if delete_procurement_buildings
      end

      context 'when there are no active_procurement_buildings' do
        let(:delete_procurement_buildings) { true }

        pending 'redirects to the edit page with the buildings section' do
          expect(response).to redirect_to edit_facilities_management_rm6232_procurement_detail_path(procurement, section: section_name)
        end
      end

      context 'when there are active_procurement_buildings' do
        let(:delete_procurement_buildings) { false }

        render_views

        pending 'renders the contract_periods partial' do
          expect(response).to render_template(partial: '_buildings')
        end

        it 'sets the procurement' do
          expect(assigns(:procurement)).to eq procurement
        end
      end
    end

    context 'when the user wants to assign services to buildings' do
      let(:section_name) { 'buildings-and-services' }

      render_views

      pending 'renders the contract_periods partial' do
        expect(response).to render_template(partial: '_buildings_and_services')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end
    end
  end

  describe 'GET edit' do
    before { get :edit, params: { procurement_id: procurement.id, section: section_name } }

    context 'when the show page is not recognised' do
      let(:section_name) { 'services-and-buildings' }

      it 'redirects to the procurement show page' do
        expect(response).to redirect_to facilities_management_rm6232_procurement_path(procurement)
      end
    end

    context 'when the user does not own the procurement' do
      let(:section_name) { 'services-and-buildings' }
      let(:user) { create(:user) }

      it 'redirects to the not permitted path' do
        expect(response).to redirect_to facilities_management_rm6232_not_permitted_path
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

    context 'when the user wants to edit the annual contract value' do
      let(:section_name) { 'annual-contract-value' }

      render_views

      it 'renders the annual_contract_value partial' do
        expect(response).to render_template(partial: '_annual_contract_value')
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
        expect(assigns(:procurement).call_off_extensions.map(&:facilities_management_rm6232_procurement_id).all? { |id| id == procurement.id }).to be true
      end

      context 'when the procurement already has extensions' do
        let(:procurement) { create(:facilities_management_rm6232_procurement_with_extension_periods, user: user) }

        it 'finds the extensions' do
          expect(assigns(:procurement).call_off_extensions.length).to eq 4
          expect(assigns(:procurement).call_off_extensions.map(&:id).none?(&:nil?)).to be true
          expect(assigns(:procurement).call_off_extensions.map(&:facilities_management_rm6232_procurement_id).all? { |id| id == procurement.id }).to be true
        end
      end
    end

    context 'when the user wants to edit the services' do
      let(:section_name) { 'services' }

      render_views

      pending 'renders the services partial' do
        expect(response).to render_template(partial: '_services')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end
    end

    context 'when the user wants to edit the buildings' do
      let(:section_name) { 'buildings' }

      render_views

      pending 'renders the buildings partial' do
        expect(response).to render_template(partial: '_buildings')
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end
    end
  end

  describe 'PUT update' do
    before { put :update, params: { procurement_id: procurement.id, section: section_name, facilities_management_rm6232_procurement: update_params } }

    context 'when updating the contract name' do
      let(:section_name) { 'contract-name' }

      context 'and the data is valid' do
        let(:update_params) { { contract_name: 'Hello there' } }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_rm6232_procurement_path(procurement)
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
        let(:update_params) { { annual_contract_value: 87_654 } }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_rm6232_procurement_path(procurement)
        end

        it 'does no update the unpermitted attribute' do
          expect { procurement.reload }.not_to change(procurement, :annual_contract_value)
        end
      end
    end

    context 'when updating the annual contract value' do
      let(:section_name) { 'annual-contract-value' }

      context 'and the data is valid' do
        let(:update_params) { { annual_contract_value: '567890' } }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_rm6232_procurement_path(procurement)
        end

        it 'updates the annual contract value' do
          expect { procurement.reload }.to change(procurement, :annual_contract_value)

          expect(procurement.annual_contract_value).to eq(567_890)
        end
      end

      context 'and the data is not valid' do
        let(:update_params) { { annual_contract_value: nil } }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'does not update the annual contract value' do
          expect { procurement.reload }.not_to change(procurement, :annual_contract_value)
        end
      end

      context 'and an unpermitted parameters are passed in' do
        let(:update_params) { { contract_name: 'Hello there' } }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_rm6232_procurement_path(procurement)
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
          expect(response).to redirect_to facilities_management_rm6232_procurement_path(procurement)
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
        let(:update_params) { { contract_name: 'Hello there' } }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_rm6232_procurement_path(procurement)
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
          expect(response).to redirect_to facilities_management_rm6232_procurement_detail_path(procurement, 'contract-period')
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
                   'facilities_management_rm6232_procurement_id',
                   'extension',
                   'years',
                   'months'
                 )).to eq(
                   {
                     'facilities_management_rm6232_procurement_id' => procurement.id,
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

        it 'does not update tupe' do
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
        let(:update_params) { { contract_name: 'Hello there' } }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_rm6232_procurement_detail_path(procurement, 'contract-period')
        end

        it 'does no update the unpermitted attribute' do
          expect { procurement.reload }.not_to change(procurement, :contract_name)
        end
      end
    end
  end
end
