require 'rails_helper'

RSpec.describe FacilitiesManagement::BuildingsController, type: :controller do
  let(:default_params) { { service: 'facilities_management', framework: framework } }
  let(:framework) { 'RM3830' }

  render_views

  describe 'GET #index' do
    context 'when logging in as a fm buyer with details' do
      login_fm_buyer_with_details

      it 'render the index' do
        get :index

        expect(response).to render_template(:index)
      end
    end

    context 'when the framework is not recognised' do
      login_fm_buyer_with_details

      let(:framework) { 'RM3840' }

      before { get :index }

      it 'renders the unrecognised framework page with the right http status' do
        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end

      it 'sets the framework variables' do
        expect(assigns(:unrecognised_framework)).to eq 'RM3840'
        expect(controller.params[:framework]).to eq FacilitiesManagement::Framework.default_framework
      end
    end

    context 'when logging in as a buyer without permissions' do
      login_buyer_without_permissions

      it 'redirects to the not permitted page' do
        get :index

        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end

    context 'when logging in without buyer details' do
      login_fm_buyer

      it 'is expected to redirect to edit_facilities_management_buyer_detail_path' do
        get :index

        expect(response).to redirect_to edit_facilities_management_buyer_detail_path(framework, controller.current_user.buyer_detail)
      end
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:found)
    end

    context 'when logging in as a buyer without permissions' do
      login_buyer_without_permissions

      it 'redirects to the not permitted page' do
        get :new
        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end

    context 'when logged in as FM buyer' do
      login_fm_buyer_with_details

      it 'has correct backlink text and destination' do
        get :new
        expect(assigns(:page_description).back_button.text).to eq 'Return to buildings'
        expect(assigns(:page_description).back_button.url).to eq facilities_management_buildings_path(framework)
      end
    end
  end

  describe 'building steps' do
    context 'when new' do
      it 'step title is correct' do
        expect(controller.step_title(:new)).to eq(I18n.t('facilities_management.buildings.step_title.step_title', position: 1))
      end

      it 'step footer is correct' do
        expect(controller.step_footer(:gia)).to eq(I18n.t('facilities_management.buildings.step_footer.step_footer', description: Buildings::BuildingsControllerNavigation::STEPS[:type][:description]))
      end
    end

    context 'with next_step' do
      it 'will be edit' do
        expect(controller.next_step(:security)).to eq :show
      end

      it 'will be type' do
        expect(controller.next_step(:gia)).to eq :type
      end
    end
  end

  describe '#ensure_postcode_is_valid' do
    context 'when the postcode is blank' do
      it 'returns the blank postcode' do
        expect(controller.ensure_postcode_is_valid('')).to eq ''
      end
    end

    context 'when the postcode is empty space' do
      it 'returns the blank postcode' do
        expect(controller.ensure_postcode_is_valid('  ')).to eq '  '
        expect(controller.ensure_postcode_is_valid(' ')).to eq ' '
      end
    end

    context 'when the postcode is not a valid postcode' do
      it 'returns the blank postcode' do
        postcode1 = "#{('aa1'..'zz9').to_a.sample} #{('1a'..'9z').to_a.sample}"
        postcode2 = "#{('aa11a'..'zz99z').to_a.sample} #{('1a'..'9z').to_a.sample}"
        postcode3 = "#{('aa1'..'zz9').to_a.sample} #{('1a'..'9z').to_a.sample}"
        expect(controller.ensure_postcode_is_valid(postcode1)).to eq postcode1.upcase
        expect(controller.ensure_postcode_is_valid(postcode2)).to eq postcode2.upcase
        expect(controller.ensure_postcode_is_valid(postcode3)).to eq postcode3.upcase
      end
    end

    context 'when the postcode is a valid postcode' do
      it 'returns the matching postcode' do
        postcode1 = "#{('aa1'..'zz9').to_a.sample} #{('1aa'..'9zz').to_a.sample}"
        postcode2 = "#{('aa1'..'zz9').to_a.sample} #{('1aa'..'9zz').to_a.sample}"
        expect(controller.ensure_postcode_is_valid(postcode1)).to eq postcode1.upcase
        expect(controller.ensure_postcode_is_valid(postcode2)).to eq postcode2.upcase
      end
    end
  end

  describe 'GET #show' do
    context 'when logging in as the fm buyer that created the building' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details

      before { get :show, params: { id: building.id } }

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'has correct backlink text and destination' do
        expect(assigns(:page_description).back_button.text).to eq 'Return to buildings'
        expect(assigns(:page_description).back_button.url).to eq facilities_management_buildings_path(framework)
      end
    end

    context 'when logging in a different fm buyer' do
      let(:building) { create(:facilities_management_building, user_id: create(:user).id) }

      login_fm_buyer_with_details
      it 'redirects to the not permitted page' do
        get :show, params: { id: building.id }

        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end
  end

  describe 'GET #edit' do
    let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

    login_fm_buyer_with_details

    before { get :edit, params: { id: building.id, step: step } }

    context 'when the step is not recognised' do
      let(:step) { 'contract_name' }

      it 'redirects to the show page' do
        expect(response).to redirect_to facilities_management_building_path(framework, building)
      end
    end

    context 'when the step is building_details' do
      let(:step) { 'building_details' }

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'has the correct title' do
        expect(assigns(:page_description).heading_details.text).to eq 'Building details'
      end

      it 'has correct backlink text and destination' do
        expect(assigns(:page_description).back_button.text).to eq 'Return to building details summary'
        expect(assigns(:page_description).back_button.url).to eq facilities_management_building_path(framework, building, step: 'building_details')
      end
    end

    context 'when the step is gia' do
      let(:step) { 'gia' }

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'has the correct title' do
        expect(assigns(:page_description).heading_details.text).to eq 'Internal and external areas'
      end

      it 'has correct backlink text and destination' do
        expect(assigns(:page_description).back_button.text).to eq 'Return to building details'
        expect(assigns(:page_description).back_button.url).to eq edit_facilities_management_building_path(framework, building, step: 'building_details')
      end
    end

    context 'when the step is type' do
      let(:step) { 'type' }

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'has the correct title' do
        expect(assigns(:page_description).heading_details.text).to eq 'Building type'
      end

      it 'has correct backlink text and destination' do
        expect(assigns(:page_description).back_button.text).to eq 'Return to building size'
        expect(assigns(:page_description).back_button.url).to eq edit_facilities_management_building_path(framework, building, step: 'gia')
      end
    end

    context 'when the step is security' do
      let(:step) { 'security' }

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'has the correct title' do
        expect(assigns(:page_description).heading_details.text).to eq 'Security clearance'
      end

      it 'has correct backlink text and destination' do
        expect(assigns(:page_description).back_button.text).to eq 'Return to building type'
        expect(assigns(:page_description).back_button.url).to eq edit_facilities_management_building_path(framework, building, step: 'type')
      end
    end
  end

  describe 'POST' do
    login_fm_buyer_with_details
    context 'when creating without a name' do
      it 'returns validation message' do
        post :create, params: { facilities_management_building: { building_name: '', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('#building_name-error')
      end
    end

    context 'when creating without an address_line_1' do
      it 'returns validation message' do
        post :create, params: { facilities_management_building: { building_name: 'name', address_line_1: '', address_town: 'town', address_postcode: 'SW1A 1AA' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('#base-error')
      end
    end

    context 'when creating without an address_town' do
      it 'returns validation message' do
        post :create, params: { facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: '', address_postcode: 'SW1A 1AA' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('#address_region-error')
      end
    end

    context 'when creating without a postcode' do
      it 'returns validation message' do
        post :create, params: { facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: 'town', address_postcode: '' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('#address_postcode-error')
      end
    end

    context 'when adding a manual address' do
      it 'show the add_address page' do
        post :create, params: { add_address: 'add_address', facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to render_template(:add_address)
      end

      it 'shows create page when address manually added' do
        post :create, params: { step: 'add_address', facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA' } }
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
      end
    end

    context 'when saving correct building' do
      it 'will redirect to gia' do
        post :create, params: { facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA', address_region: 'Inner London - West', address_region_code: 'UKI3' } }
        expect(response).to have_http_status(:found)

        expect(response.headers['Location']).to include('gia')
      end

      it 'will redirect to building' do
        post :create, params: { save_and_return: '', facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA', address_region: 'Inner London - West', address_region_code: 'UKI3' } }
        expect(response).to have_http_status(:found)
        id = controller.current_user.buildings.first.id
        expect(response.headers['Location']).to redirect_to(facilities_management_building_path(framework, id))
      end
    end

    context 'when address_postcode is in lower case' do
      it 'will cast it to upper case' do
        post :create, params: { facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'sw1a 1aa', address_region: 'Inner London - West', address_region_code: 'UKI3' } }

        expect(FacilitiesManagement::Building.last.address_postcode).to eq('SW1A 1AA')
      end
    end

    context 'when adding a manual address and address_postcode is in lower case' do
      it 'will cast it to upper case' do
        post :create, params: { add_address: 'add_address', facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'sw1a 1aa', address_region: 'Inner London - West', address_region_code: 'UKI3' } }

        expect(assigns(:page_data)[:model_object].address_postcode).to eq('SW1A 1AA')
      end
    end

    context 'when on add_address step and address_postcode is in lower case' do
      it 'will cast it to upper case' do
        post :create, params: { step: 'add_address', facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'sw1a 1aa', address_region: 'Inner London - West', address_region_code: 'UKI3' } }

        expect(assigns(:page_data)[:model_object].address_postcode).to eq('SW1A 1AA')
      end
    end
  end

  describe 'Postcode games' do
    let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

    login_fm_buyer_with_details
    context 'when saving without a postcode' do
      it 'will reject the empty password with a postcode.blank message' do
        patch :update, params: { id: building.id, step: 'building_details', facilities_management_building: { address_postcode: '', address_region: '', address_region_code: '' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(I18n.t('activerecord.errors.models.facilities_management/building.attributes.address_postcode.blank'))
      end

      it 'will reject the empty password with a address not_selected message' do
        patch :update, params: { id: building.id, step: 'building_details', facilities_management_building: { address_line_1: '', address_town: '', address_line_2: '', address_postcode: 'SW1A 1AA', address_region: '', address_region_code: '' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(I18n.t('activerecord.errors.models.facilities_management/building.attributes.base.not_selected'))
      end

      it 'will reject an empty region for when none can be selected' do
        patch :update, params: { id: building.id, step: 'building_details', facilities_management_building: { address_line_1: 'line 1', address_town: 'town', address_line_2: 'line 2', address_postcode: 'SW1A 1AA', address_region: '', address_region_code: '' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(I18n.t('activerecord.errors.models.facilities_management/building.attributes.address_region.blank'))
      end

      it 'will not reject an empty region for when none can be selected' do
        patch :update, params: { id: building.id, step: 'building_details', facilities_management_building: { address_line_1: 'line 2', address_town: 'town 2', address_line_2: 'line 22', address_postcode: 'SW2A 1AA', address_region: 'test', address_region_code: 'test_code' } }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to edit_facilities_management_building_path(framework, building.id, step: 'gia')
        building.reload
        expect(building[:address_postcode]).to eq('SW2A 1AA')
      end
    end

    context 'when postcode is in lowercase' do
      it 'will cast postcode to uppercase' do
        patch :update, params: { id: building.id, step: 'building_details', facilities_management_building: { address_line_1: 'line 2', address_town: 'town 2', address_line_2: 'line 22', address_postcode: 'sw2a 1aa', address_region: 'test', address_region_code: 'test_code' } }
        building.reload
        expect(building[:address_postcode]).to eq('SW2A 1AA')
      end
    end
  end

  describe 'PUT' do
    context 'when saving GIA' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details
      context 'when saving with empty value' do
        it 'returns validation message' do
          patch :update, params: { id: building.id, step: 'gia', facilities_management_building: { gia: '' } }
          expect(response).to have_http_status(:ok)
          expect(response.body).to include('#gia-error')
        end
      end

      context 'when saving with valid value' do
        it 'redirects to next step' do
          patch :update, params: { id: building.id, step: 'gia', facilities_management_building: { gia: '5432' } }
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to edit_facilities_management_building_path(framework, building.id, step: 'type')
          building.reload
          expect(building.gia).to eq(5432)
        end
      end
    end

    context 'when saving building type' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details
      context 'when saving with empty value' do
        it 'returns validation message' do
          patch :update, params: { id: building.id, step: 'type', facilities_management_building: { building_type: '' } }
          expect(response).to have_http_status(:ok)
          expect(response.body).to include('#building_type-error')
        end
      end

      context 'when saving with valid value' do
        it 'returns validation message' do
          patch :update, params: { id: building.id, step: 'type', facilities_management_building: { building_type: 'other', other_building_type: 'test' } }
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to edit_facilities_management_building_path(framework, building.id, step: 'security')
          building.reload
          expect(building.building_type).to eq('other')
        end
      end
    end

    context 'when saving security type' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details
      context 'when saving with empty value' do
        it 'returns validation message' do
          patch :update, params: { id: building.id, step: 'security', facilities_management_building: { security_type: '' } }
          expect(response).to have_http_status(:ok)
          expect(response.body).to include('#security_type-error')
        end
      end

      context 'when saving with valid value' do
        it 'returns validation message' do
          patch :update, params: { id: building.id, step: 'security', facilities_management_building: { security_type: 'other', other_security_type: 'test' } }
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to facilities_management_building_path(framework)
          building.reload
          expect(building.security_type).to eq('other')
        end
      end
    end

    context 'when editing add_address' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details

      it 'will redirect to add_address' do
        get :add_address, params: { id: building.id }
        expect(response).to render_template 'add_address'
      end

      it 'has correct backlink text and destination' do
        get :add_address, params: { id: building.id }
        expect(assigns(:page_description).back_button.text).to eq 'Return to building details'
        expect(assigns(:page_description).back_button.url).to eq edit_facilities_management_building_path(framework, building, step: 'building_details')
      end

      it 'will display validation error' do
        patch :update, params: { id: building.id, step: 'add_address', facilities_management_building: { address_line_1: '' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('#address_line_1-error')
      end

      it 'will render the edit page' do
        patch :update, params: { id: building.id, step: 'add_address', facilities_management_building: { address_line_1: 'line1', address_town: 'town', address_postcode: 'SW1A 1AA' } }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to edit_facilities_management_building_path(framework, building.id, step: 'building_details')
        building.reload
        expect(building.address_town).to eq('town')
      end
    end
  end
end
