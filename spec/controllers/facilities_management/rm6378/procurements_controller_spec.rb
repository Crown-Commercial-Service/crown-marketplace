require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::ProcurementsController do
  let(:default_params) { { service: 'facilities_management', framework: 'RM6378' } }
  let(:user) { controller.current_user }

  login_fm_buyer_with_details

  context 'without buyer details' do
    login_fm_buyer

    it 'redirects to buyer details' do
      get :new

      expect(response).to redirect_to edit_facilities_management_buyer_detail_path(id: user.buyer_detail.id)
    end
  end

  describe 'GET index' do
    before do
      create_list(:facilities_management_rm6378_procurement, 5, user:)
      get :index
    end

    it 'renders the correct template' do
      expect(response).to render_template('index')
    end

    it 'groups up the procurements' do
      expect(assigns(:searches).length).to eq 5
    end

    it 'sets the back path' do
      expect(assigns(:back_path)).to eq facilities_management_rm6378_path
      expect(assigns(:back_text)).to eq 'Return to your account'
    end
  end

  describe 'GET new' do
    let(:service_codes) { ['E1', 'E2'] }

    before { get :new, params: { annual_contract_value: 123_456, region_codes: ['TLH3', 'TLH5'], service_codes: service_codes } }

    it 'renders the correct template' do
      expect(response).to render_template('new')
    end

    it 'sets the back path' do
      expect(assigns(:back_path)).to eq '/facilities-management/RM6378/annual-contract-value?annual_contract_value=123456&region_codes%5B%5D=TLH3&region_codes%5B%5D=TLH5&service_codes%5B%5D=E1&service_codes%5B%5D=E2'
      expect(assigns(:back_text)).to eq 'Return to annual contract cost'
    end

    context 'when there search results in one procurement' do
      it 'sets the journey attributes' do
        expect(assigns(:services).pluck(:id)).to eq(['RM6378.2a.E1', 'RM6378.2a.E2'])
        expect(assigns(:regions).pluck(:id)).to eq(['TLH3', 'TLH5'])
        expect(assigns(:annual_contract_value)).to eq(123_456)
      end

      it 'sets one procurement' do
        expect(assigns(:procurements).length).to eq(1)
      end

      # rubocop:disable RSpec/ExampleLength
      it 'sets the single procurement with the correct details' do
        expect(assigns(:procurements)[0].attributes.deep_symbolize_keys.slice(:user_id, :framework_id, :lot_id, :procurement_details)).to eq(
          {
            user_id: controller.current_user.id,
            framework_id: 'RM6378',
            lot_id: 'RM6378.2a',
            procurement_details: {
              service_ids: ['RM6378.2a.E1', 'RM6378.2a.E2'],
              jurisdiction_ids: ['TLH3', 'TLH5'],
              annual_contract_value: 123_456
            }
          }
        )
      end
      # rubocop:enable RSpec/ExampleLength
    end

    context 'when there search results in two procurements' do
      let(:service_codes) { ['E1', 'E2', 'X1', 'Y1'] }

      it 'sets the journey attributes' do
        expect(assigns(:services).pluck(:id)).to eq(['RM6378.2a.E1', 'RM6378.2a.E2', 'RM6378.4d.X1', 'RM6378.4d.Y1'])
        expect(assigns(:regions).pluck(:id)).to eq(['TLH3', 'TLH5'])
        expect(assigns(:annual_contract_value)).to eq(123_456)
      end

      it 'sets two procurements' do
        expect(assigns(:procurements).length).to eq(2)
      end

      # rubocop:disable RSpec/ExampleLength
      it 'sets the first procurement with the correct details' do
        expect(assigns(:procurements)[0].attributes.deep_symbolize_keys.slice(:user_id, :framework_id, :lot_id, :procurement_details)).to eq(
          {
            user_id: controller.current_user.id,
            framework_id: 'RM6378',
            lot_id: 'RM6378.2a',
            procurement_details: {
              service_ids: ['RM6378.2a.E1', 'RM6378.2a.E2'],
              jurisdiction_ids: ['TLH3', 'TLH5'],
              annual_contract_value: 123_456
            }
          }
        )
      end

      it 'sets the second procurement with the correct details' do
        expect(assigns(:procurements)[1].attributes.deep_symbolize_keys.slice(:user_id, :framework_id, :lot_id, :procurement_details)).to eq(
          {
            user_id: controller.current_user.id,
            framework_id: 'RM6378',
            lot_id: 'RM6378.4d',
            procurement_details: {
              service_ids: ['RM6378.4d.X1', 'RM6378.4d.Y1'],
              jurisdiction_ids: ['TLH3', 'TLH5'],
              annual_contract_value: 123_456
            }
          }
        )
      end
      # rubocop:enable RSpec/ExampleLength
    end
  end

  describe 'POST create' do
    let(:service_codes) { ['E1', 'E2'] }
    let(:contract_name) { 'Zote' }
    let(:requirements_linked_to_pfi) { true }

    context 'when there is one procurement' do
      before { post :create, params: { annual_contract_value: 123_456, region_codes: ['TLH3', 'TLH5'], service_codes: service_codes, facilities_management_rm6378_procurement: { contract_name:, requirements_linked_to_pfi: } } }

      shared_examples 'and attributes are set' do
        it 'sets the journey attributes' do
          expect(assigns(:services).pluck(:id)).to eq(['RM6378.2a.E1', 'RM6378.2a.E2'])
          expect(assigns(:regions).pluck(:id)).to eq(['TLH3', 'TLH5'])
          expect(assigns(:annual_contract_value)).to eq(123_456)
        end

        it 'sets one procurement' do
          expect(assigns(:procurements).length).to eq(1)
        end

        # rubocop:disable RSpec/ExampleLength
        it 'sets the single procurement with the correct details' do
          expect(assigns(:procurements)[0].attributes.deep_symbolize_keys.slice(:user_id, :framework_id, :lot_id, :procurement_details, :contract_name)).to eq(
            {
              user_id: controller.current_user.id,
              framework_id: 'RM6378',
              lot_id: 'RM6378.2a',
              procurement_details: {
                service_ids: ['RM6378.2a.E1', 'RM6378.2a.E2'],
                jurisdiction_ids: ['TLH3', 'TLH5'],
                annual_contract_value: 123_456,
                requirements_linked_to_pfi: requirements_linked_to_pfi,
              },
              contract_name: contract_name,
            }
          )
        end
        # rubocop:enable RSpec/ExampleLength
      end

      context 'and it is not valid due to the contract name being blank' do
        let(:contract_name) { '' }

        include_context 'and attributes are set'

        it 'sets the erros on the procurement' do
          expect(assigns(:procurements)[0].errors.details.keys).to eq([:contract_name])
        end

        it 'renders the new template' do
          expect(response).to render_template('new')
        end
      end

      context 'and it is not valid due to the requirements linked to pfi being blank' do
        let(:requirements_linked_to_pfi) { nil }

        include_context 'and attributes are set'

        it 'sets the erros on the procurement' do
          expect(assigns(:procurements)[0].errors.details.keys).to eq([:requirements_linked_to_pfi])
        end

        it 'renders the new template' do
          expect(response).to render_template('new')
        end
      end

      context 'and it is valid' do
        include_context 'and attributes are set'

        it 'redirects to the show page' do
          new_procurement = FacilitiesManagement::RM6378::Procurement.find_by(contract_name: 'Zote')

          expect(response).to redirect_to facilities_management_rm6378_procurement_path(new_procurement.id)
        end

        it 'does not create a flash message' do
          expect(flash[:second_procurement_name]).not_to be_present
        end
      end
    end

    context 'when there are two procurements' do
      let(:service_codes) { ['E1', 'E2', 'X1', 'Y1'] }
      let(:expected_second_contract_name) { "#{contract_name} (Security)" }

      shared_examples 'and attributes are set' do
        it 'sets the journey attributes' do
          expect(assigns(:services).pluck(:id)).to eq(['RM6378.2a.E1', 'RM6378.2a.E2', 'RM6378.4d.X1', 'RM6378.4d.Y1'])
          expect(assigns(:regions).pluck(:id)).to eq(['TLH3', 'TLH5'])
          expect(assigns(:annual_contract_value)).to eq(123_456)
        end

        it 'sets two procurements' do
          expect(assigns(:procurements).length).to eq(2)
        end

        # rubocop:disable RSpec/ExampleLength
        it 'sets the first procurement with the correct details' do
          expect(assigns(:procurements)[0].attributes.deep_symbolize_keys.slice(:user_id, :framework_id, :lot_id, :procurement_details, :contract_name)).to eq(
            {
              user_id: controller.current_user.id,
              framework_id: 'RM6378',
              lot_id: 'RM6378.2a',
              procurement_details: {
                service_ids: ['RM6378.2a.E1', 'RM6378.2a.E2'],
                jurisdiction_ids: ['TLH3', 'TLH5'],
                annual_contract_value: 123_456,
                requirements_linked_to_pfi: requirements_linked_to_pfi,
              },
              contract_name: contract_name,
            }
          )
        end

        it 'sets the second procurement with the correct details' do
          expect(assigns(:procurements)[1].attributes.deep_symbolize_keys.slice(:user_id, :framework_id, :lot_id, :procurement_details, :contract_name)).to eq(
            {
              user_id: controller.current_user.id,
              framework_id: 'RM6378',
              lot_id: 'RM6378.4d',
              procurement_details: {
                service_ids: ['RM6378.4d.X1', 'RM6378.4d.Y1'],
                jurisdiction_ids: ['TLH3', 'TLH5'],
                annual_contract_value: 123_456,
                requirements_linked_to_pfi: requirements_linked_to_pfi,
              },
              contract_name: expected_second_contract_name,
            }
          )
        end
        # rubocop:enable RSpec/ExampleLength
      end

      context 'and it is not valid due to the contract name being blank' do
        let(:contract_name) { '' }
        let(:expected_second_contract_name) { '' }

        before { post :create, params: { annual_contract_value: 123_456, region_codes: ['TLH3', 'TLH5'], service_codes: service_codes, facilities_management_rm6378_procurement: { contract_name:, requirements_linked_to_pfi: } } }

        include_context 'and attributes are set'

        it 'sets the erros on the first procurement' do
          expect(assigns(:procurements)[0].errors.details.keys).to eq([:contract_name])
          expect(assigns(:procurements)[1].errors).not_to be_any
        end

        it 'renders the new template' do
          expect(response).to render_template('new')
        end
      end

      context 'and it is not valid due to the requirements linked to pfi being blank' do
        let(:requirements_linked_to_pfi) { nil }
        let(:expected_second_contract_name) { contract_name }

        before { post :create, params: { annual_contract_value: 123_456, region_codes: ['TLH3', 'TLH5'], service_codes: service_codes, facilities_management_rm6378_procurement: { contract_name:, requirements_linked_to_pfi: } } }

        include_context 'and attributes are set'

        it 'sets the erros on the procurement' do
          expect(assigns(:procurements)[0].errors.details.keys).to eq([:requirements_linked_to_pfi])
          expect(assigns(:procurements)[1].errors).not_to be_any
        end

        it 'renders the new template' do
          expect(response).to render_template('new')
        end
      end

      context 'and the security name is taken' do
        let(:expected_second_contract_name) { contract_name }

        before do
          # rubocop:disable RSpec/AnyInstance
          allow_any_instance_of(FacilitiesManagement::RM6378::Procurement).to receive(:update_contract_name_with_security).and_raise(FacilitiesManagement::RM6378::Procurement::CannotCreateNameError.new)
          # rubocop:enable RSpec/AnyInstance

          post :create, params: { annual_contract_value: 123_456, region_codes: ['TLH3', 'TLH5'], service_codes: service_codes, facilities_management_rm6378_procurement: { contract_name:, requirements_linked_to_pfi: } }
        end

        include_context 'and attributes are set'

        it 'sets the erros on the procurement' do
          expect(assigns(:procurements)[0].errors.details).to eq({ contract_name: [{ error: :taken }] })
          expect(assigns(:procurements)[1].errors).not_to be_any
        end

        it 'renders the new template' do
          expect(response).to render_template('new')
        end
      end

      context 'and there is an error saving' do
        before do
          # rubocop:disable RSpec/AnyInstance
          allow_any_instance_of(FacilitiesManagement::RM6378::Procurement).to receive(:save!).and_raise(ActiveRecord::Rollback.new('Something went wrong'))
          # rubocop:enable RSpec/AnyInstance

          post :create, params: { annual_contract_value: 123_456, region_codes: ['TLH3', 'TLH5'], service_codes: service_codes, facilities_management_rm6378_procurement: { contract_name:, requirements_linked_to_pfi: } }
        end

        include_context 'and attributes are set'

        it 'sets the erros on the procurement' do
          expect(assigns(:procurements)[0].errors.details).to eq({ contract_name: [{ error: :taken }] })
          expect(assigns(:procurements)[1].errors).not_to be_any
        end

        it 'renders the new template' do
          expect(response).to render_template('new')
        end
      end

      context 'and it is valid' do
        before { post :create, params: { annual_contract_value: 123_456, region_codes: ['TLH3', 'TLH5'], service_codes: service_codes, facilities_management_rm6378_procurement: { contract_name:, requirements_linked_to_pfi: } } }

        include_context 'and attributes are set'

        it 'redirects to the show page' do
          new_procurement = FacilitiesManagement::RM6378::Procurement.find_by(contract_name: 'Zote')

          expect(response).to redirect_to facilities_management_rm6378_procurement_path(new_procurement.id)
        end

        it 'does create a flash message' do
          expect(flash[:second_procurement_name]).to eq(expected_second_contract_name)
        end
      end
    end
  end
end
