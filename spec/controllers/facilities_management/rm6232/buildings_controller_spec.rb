# This has been cut but it may return on the future
# require 'rails_helper'

# RSpec.describe FacilitiesManagement::RM6232::BuildingsController, type: :controller do
#   let(:default_params) { { service: 'facilities_management', framework: framework } }
#   let(:framework) { 'RM6232' }
#   let(:building) { create(:facilities_management_building, user: user) }
#   let(:user) { controller.current_user }

#   describe 'GET #index' do
#     context 'when logging in as a fm buyer with details' do
#       login_fm_buyer_with_details

#       it 'render the index' do
#         get :index

#         expect(response).to render_template(:index)
#       end
#     end

#     context 'when the framework is not recognised' do
#       login_fm_buyer_with_details

#       let(:framework) { 'RM3840' }

#       before { get :index }

#       it 'renders the unrecognised framework page with the right http status' do
#         expect(response).to render_template('home/unrecognised_framework')
#         expect(response).to have_http_status(:bad_request)
#       end

#       it 'sets the framework variables' do
#         expect(assigns(:unrecognised_framework)).to eq 'RM3840'
#         expect(controller.params[:framework]).to eq Framework.facilities_management.current_framework
#       end
#     end

#     context 'when logging in as a buyer without permissions' do
#       login_buyer_without_permissions

#       it 'redirects to the not permitted page' do
#         get :index

#         expect(response).to redirect_to '/facilities-management/RM6232/not-permitted'
#       end
#     end

#     context 'when logging in without buyer details' do
#       login_fm_buyer

#       it 'is expected to redirect to edit_facilities_management_buyer_detail_path' do
#         get :index

#         expect(response).to redirect_to edit_facilities_management_buyer_detail_path(framework, controller.current_user.buyer_detail)
#       end
#     end
#   end

#   describe 'GET #show' do
#     login_fm_buyer_with_details

#     before { get :show, params: { id: building.id } }

#     context 'when logging in as the fm buyer that created the building' do
#       it 'render the show page' do
#         expect(response).to render_template(:show)
#       end

#       it 'has correct backlink text and destination' do
#         expect(assigns(:back_text)).to eq 'Return to buildings'
#         expect(assigns(:back_path)).to eq facilities_management_rm6232_buildings_path
#       end
#     end

#     context 'when logging in a different fm buyer' do
#       let(:user) { create(:user) }

#       it 'redirects to the not permitted page' do
#         expect(response).to redirect_to '/facilities-management/RM6232/not-permitted'
#       end
#     end
#   end

#   describe 'GET #new' do
#     context 'when logging in as a buyer without permissions' do
#       login_buyer_without_permissions

#       it 'redirects to the not permitted page' do
#         get :new

#         expect(response).to redirect_to '/facilities-management/RM6232/not-permitted'
#       end
#     end

#     context 'when logged in as FM buyer' do
#       login_fm_buyer_with_details

#       before { get :new }

#       it 'render the new page' do
#         expect(response).to render_template(:new)
#       end

#       it 'has correct backlink text and destination' do
#         expect(assigns(:back_text)).to eq 'Return to buildings'
#         expect(assigns(:back_path)).to eq facilities_management_rm6232_buildings_path
#       end
#     end
#   end

#   describe 'GET #edit' do
#     login_fm_buyer_with_details

#     before { get :edit, params: { id: building.id, section: section } }

#     render_views

#     context 'when the section is not recognised' do
#       let(:section) { 'contract_name' }

#       it 'redirects to the show page' do
#         expect(response).to redirect_to facilities_management_rm6232_building_path(building)
#       end
#     end

#     context 'when the section is building_details' do
#       let(:section) { 'building_details' }

#       it 'returns http success' do
#         expect(response).to have_http_status(:ok)
#       end

#       it 'renders the building_details template' do
#         expect(response).to render_template('_building_details')
#       end

#       it 'has correct backlink text and destination' do
#         expect(assigns(:back_text)).to eq 'Return to building details summary'
#         expect(assigns(:back_path)).to eq facilities_management_rm6232_building_path(building)
#       end
#     end

#     context 'when the section is add_address' do
#       let(:section) { 'add_address' }

#       it 'returns http success' do
#         expect(response).to have_http_status(:ok)
#       end

#       it 'renders the add_address template' do
#         expect(response).to render_template('_add_address')
#       end

#       it 'has correct backlink text and destination' do
#         expect(assigns(:back_text)).to eq 'Return to building details'
#         expect(assigns(:back_path)).to eq edit_facilities_management_rm6232_building_path(building, section: 'building_details')
#       end
#     end

#     context 'when the section is building_area' do
#       let(:section) { 'building_area' }

#       it 'returns http success' do
#         expect(response).to have_http_status(:ok)
#       end

#       it 'renders the building_area template' do
#         expect(response).to render_template('_building_area')
#       end

#       it 'has correct backlink text and destination' do
#         expect(assigns(:back_text)).to eq 'Return to building details'
#         expect(assigns(:back_path)).to eq edit_facilities_management_rm6232_building_path(building, section: 'building_details')
#       end
#     end

#     context 'when the section is building_type' do
#       let(:section) { 'building_type' }

#       it 'returns http success' do
#         expect(response).to have_http_status(:ok)
#       end

#       it 'renders the building_type template' do
#         expect(response).to render_template('_building_type')
#       end

#       it 'has correct backlink text and destination' do
#         expect(assigns(:back_text)).to eq 'Return to building size'
#         expect(assigns(:back_path)).to eq edit_facilities_management_rm6232_building_path(building, section: 'building_area')
#       end
#     end

#     context 'when the section is security_type' do
#       let(:section) { 'security_type' }

#       it 'returns http success' do
#         expect(response).to have_http_status(:ok)
#       end

#       it 'renders the security_type template' do
#         expect(response).to render_template('_security_type')
#       end

#       it 'has correct backlink text and destination' do
#         expect(assigns(:back_text)).to eq 'Return to building type'
#         expect(assigns(:back_path)).to eq edit_facilities_management_rm6232_building_path(building, section: 'building_type')
#       end
#     end
#   end

#   describe 'POST create' do
#     let(:options) { {} }
#     let(:building_options) { { building_name: building_name, address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA', address_region: 'Inner London - West', address_region_code: 'UKI3' } }
#     let(:building_name) { 'My building name' }

#     login_fm_buyer_with_details

#     before do
#       allow(controller).to receive(:resolve_region)
#       post :create, params: { facilities_management_building: building_options, **options }
#     end

#     context 'when the data is valid' do
#       let(:new_building) { FacilitiesManagement::Building.order(created_at: :asc).first }

#       context 'and the user clicked "Save and continue"' do
#         it 'redirects to the edit area page' do
#           expect(response).to redirect_to edit_facilities_management_rm6232_building_path(new_building.id, section: 'building_area')
#         end
#       end

#       context 'and the user clicked "Save and return to building details summary"' do
#         let(:options) { { save_and_return: 'Save and return to building details summary' } }

#         it 'redirects to the show page' do
#           expect(response).to redirect_to facilities_management_rm6232_building_path(new_building.id)
#         end
#       end
#     end

#     context 'when the data is invalid' do
#       let(:building_name) { '' }

#       it 'renders the new template' do
#         expect(response).to render_template('new')
#       end

#       it 'sets the back path and text correctly' do
#         expect(assigns(:back_text)).to eq 'Return to buildings'
#         expect(assigns(:back_path)).to eq facilities_management_rm6232_buildings_path
#       end
#     end

#     context 'when the address cannot be found' do
#       let(:options) { { add_address: "I can't find my building's address in the list" } }
#       let(:building_options) { { building_name: 'My building', address_line_1: '', address_town: '', address_postcode: 'SW1A 1AA', address_region: '', address_region_code: '' } }

#       it 'renders the add_address template' do
#         expect(response).to render_template('add_address')
#       end

#       it 'assigns the attributes to the building' do
#         building = assigns(:building)

#         expect(building.building_name).to eq 'My building'
#         expect(building.address_postcode).to eq 'SW1A 1AA'
#       end

#       it 'sets the back path and text correctly' do
#         expect(assigns(:back_text)).to eq 'Return to building details'
#         expect(assigns(:back_path)).to eq 'javascript:history.back()'
#       end
#     end

#     context 'when adding an address manually' do
#       let(:options) { { add_address: "I can't find my building's address in the list", step: 'add_address' } }
#       let(:building_options) { { building_name: 'My building', address_line_1: address_line_1, address_town: 'town', address_postcode: 'SW1A 1AA', address_region: '', address_region_code: '' } }

#       context 'and the data is valid' do
#         let(:address_line_1) { 'line 1' }

#         it 'renders the new template' do
#           expect(response).to render_template('new')
#         end

#
#         it 'assigns the attributes to the building' do
#           building = assigns(:building)

#           expect(building.building_name).to eq 'My building'
#           expect(building.address_line_1).to eq 'line 1'
#           expect(building.address_town).to eq 'town'
#           expect(building.address_postcode).to eq 'SW1A 1AA'
#         end
#         # rubocop:enable RSpec/MultipleExpectations

#         it 'attempts to resolve the region' do
#           expect(controller).to have_received(:resolve_region).with(false)
#         end

#         it 'sets the back path and text correctly' do
#           expect(assigns(:back_text)).to eq 'Return to buildings'
#           expect(assigns(:back_path)).to eq facilities_management_rm6232_buildings_path
#         end
#       end

#       context 'and the data is invalid' do
#         let(:address_line_1) { '' }

#         it 'renders the add_address template' do
#           expect(response).to render_template('add_address')
#         end

#         it 'does not attempt to resolve the region' do
#           expect(controller).not_to have_received(:resolve_region)
#         end

#         it 'sets the back path and text correctly' do
#           expect(assigns(:back_text)).to eq 'Return to building details'
#           expect(assigns(:back_path)).to eq 'javascript:history.back()'
#         end
#       end
#     end
#   end

#
#   describe 'PUT update' do
#     login_fm_buyer_with_details

#     let(:options) { {} }

#     before do
#       allow(controller).to receive(:resolve_region)
#       put :update, params: { id: building.id, section: section_name, facilities_management_building: update_params, **options }
#     end

#     context 'when updating the building details' do
#       let(:section_name) { 'building_details' }

#       context 'and the data is valid' do
#         let(:update_params) { { building_name: 'New building name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA', address_region: 'Inner London - West', address_region_code: 'UKI3' } }

#         it 'redirects to the building area edit page' do
#           expect(response).to redirect_to edit_facilities_management_rm6232_building_path(building.id, section: 'building_area')
#         end

#         it 'updates the building details' do
#           expect do
#             building.reload
#           end.to(
#             change(building, :building_name).to('New building name')
#             .and(change(building, :address_line_1).to('line 1'))
#             .and(change(building, :address_town).to('town'))
#             .and(change(building, :address_postcode).to('SW1A 1AA'))
#             .and(change(building, :address_region).to('Inner London - West'))
#             .and(change(building, :address_region_code).to('UKI3'))
#           )
#         end

#         context 'and save and return is clicked' do
#           let(:options) { { save_and_return: 'Save and return to building details summary' } }

#           it 'redirects to the show page' do
#             expect(response).to redirect_to facilities_management_rm6232_building_path(building.id)
#           end
#         end
#       end

#       context 'and the data is not valid' do
#         let(:update_params) { { building_name: '', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA', address_region: 'Inner London - West', address_region_code: 'UKI3' } }

#         it 'renders the edit page' do
#           expect(response).to render_template(:edit)
#         end

#
#         it 'does not update the building details' do
#           RSpec::Matchers.define_negated_matcher :not_change, :change

#           expect do
#             building.reload
#           end.to(
#             not_change(building, :building_name)
#             .and(not_change(building, :address_line_1))
#             .and(not_change(building, :address_town))
#             .and(not_change(building, :address_postcode))
#             .and(not_change(building, :address_region))
#             .and(not_change(building, :address_region_code))
#           )
#         end
#         # rubocop:enable RSpec/ExampleLength

#         it 'has correct backlink text and destination' do
#           expect(assigns(:back_text)).to eq 'Return to building details summary'
#           expect(assigns(:back_path)).to eq facilities_management_rm6232_building_path(building)
#         end
#       end

#       context 'and an unpermitted parameters are passed in' do
#         let(:update_params) { { building_name: 'New building name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA', address_region: 'Inner London - West', address_region_code: 'UKI3', gia: 1234 } }

#         it 'redirects to the building area edit page' do
#           expect(response).to redirect_to edit_facilities_management_rm6232_building_path(building.id, section: 'building_area')
#         end

#         it 'does no update the unpermitted attribute' do
#           expect { building.reload }.not_to change(building, :gia)
#         end
#       end
#     end

#     context 'when updating the building address' do
#       let(:section_name) { 'add_address' }

#       context 'and the data is valid' do
#         let(:update_params) { { address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA' } }

#         it 'redirects to the building details edit page' do
#           expect(response).to redirect_to edit_facilities_management_rm6232_building_path(building.id, section: 'building_details')
#         end

#         it 'updates the building address' do
#           expect do
#             building.reload
#           end.to(
#             change(building, :address_line_1).to('line 1')
#             .and(change(building, :address_town).to('town'))
#             .and(change(building, :address_postcode).to('SW1A 1AA'))
#           )
#         end

#         it 'attempts to resolve the region' do
#           expect(controller).to have_received(:resolve_region).with(true)
#         end

#         context 'and save and return is clicked' do
#           let(:options) { { save_and_return: 'Save and return to building details summary' } }

#           it 'redirects to the show page' do
#             expect(response).to redirect_to facilities_management_rm6232_building_path(building.id)
#           end
#         end
#       end

#       context 'and the data is not valid' do
#         let(:update_params) { { address_line_1: '', address_town: 'town', address_postcode: 'SW1A 1AA' } }

#         it 'renders the edit page' do
#           expect(response).to render_template(:edit)
#         end

#         it 'does not update the building address' do
#           RSpec::Matchers.define_negated_matcher :not_change, :change

#           expect do
#             building.reload
#           end.to(
#             not_change(building, :address_line_1)
#             .and(not_change(building, :address_town))
#             .and(not_change(building, :address_postcode))
#           )
#         end

#         it 'does not attempt to resolve the region' do
#           expect(controller).not_to have_received(:resolve_region)
#         end

#         it 'has correct backlink text and destination' do
#           expect(assigns(:back_text)).to eq 'Return to building details'
#           expect(assigns(:back_path)).to eq edit_facilities_management_rm6232_building_path(building, section: 'building_details')
#         end
#       end

#       context 'and an unpermitted parameters are passed in' do
#         let(:update_params) { { building_name: 'New building name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA' } }

#         it 'redirects to the building details edit page' do
#           expect(response).to redirect_to edit_facilities_management_rm6232_building_path(building.id, section: 'building_details')
#         end

#         it 'does no update the unpermitted attribute' do
#           expect { building.reload }.not_to change(building, :building_name)
#         end
#       end
#     end

#     context 'when updating the building area' do
#       let(:section_name) { 'building_area' }

#       context 'and the data is valid' do
#         let(:update_params) { { gia: 1_234, external_area: 4_321 } }

#         it 'redirects to the building type edit page' do
#           expect(response).to redirect_to edit_facilities_management_rm6232_building_path(building.id, section: 'building_type')
#         end

#         it 'updates the building areas' do
#           expect do
#             building.reload
#           end.to(
#             change(building, :gia).to(1_234)
#             .and(change(building, :external_area).to(4_321))
#           )
#         end

#         context 'and save and return is clicked' do
#           let(:options) { { save_and_return: 'Save and return to building details summary' } }

#           it 'redirects to the show page' do
#             expect(response).to redirect_to facilities_management_rm6232_building_path(building.id)
#           end
#         end
#       end

#       context 'and the data is not valid' do
#         let(:update_params) { { gia: 'freddy', external_area: 4_321 } }

#         it 'renders the edit page' do
#           expect(response).to render_template(:edit)
#         end

#         it 'does not update the building areas' do
#           RSpec::Matchers.define_negated_matcher :not_change, :change

#           expect do
#             building.reload
#           end.to(
#             not_change(building, :gia)
#             .and(not_change(building, :external_area))
#           )
#         end

#         it 'has correct backlink text and destination' do
#           expect(assigns(:back_text)).to eq 'Return to building details'
#           expect(assigns(:back_path)).to eq edit_facilities_management_rm6232_building_path(building.id, section: 'building_details')
#         end
#       end

#       context 'and an unpermitted parameters are passed in' do
#         let(:update_params) { { building_name: 'New building name', gia: 1_234, external_area: 4_321 } }

#         it 'redirects to the building area edit page' do
#           expect(response).to redirect_to edit_facilities_management_rm6232_building_path(building.id, section: 'building_type')
#         end

#         it 'does no update the unpermitted attribute' do
#           expect { building.reload }.not_to change(building, :building_name)
#         end
#       end
#     end

#     context 'when updating the building type' do
#       let(:section_name) { 'building_type' }

#       context 'and the data is valid' do
#         let(:update_params) { { building_type: 'Call Centre Operations' } }

#         it 'redirects to the security type edit page' do
#           expect(response).to redirect_to edit_facilities_management_rm6232_building_path(building.id, section: 'security_type')
#         end

#         it 'updates the building type' do
#           expect do
#             building.reload
#           end.to(
#             change(building, :building_type).to('Call Centre Operations')
#           )
#         end

#         context 'and save and return is clicked' do
#           let(:options) { { save_and_return: 'Save and return to building details summary' } }

#           it 'redirects to the show page' do
#             expect(response).to redirect_to facilities_management_rm6232_building_path(building.id)
#           end
#         end
#       end

#       context 'and the data is not valid' do
#         let(:update_params) { { building_type: '' } }

#         it 'renders the edit page' do
#           expect(response).to render_template(:edit)
#         end

#         it 'does not update the building type' do
#           RSpec::Matchers.define_negated_matcher :not_change, :change

#           expect do
#             building.reload
#           end.to(
#             not_change(building, :building_type)
#           )
#         end

#         it 'has correct backlink text and destination' do
#           expect(assigns(:back_text)).to eq 'Return to building size'
#           expect(assigns(:back_path)).to eq edit_facilities_management_rm6232_building_path(building.id, section: 'building_area')
#         end
#       end

#       context 'and an unpermitted parameters are passed in' do
#         let(:update_params) { { building_name: 'New building name', building_type: 'Call Centre Operations' } }

#         it 'redirects to the security type edit page' do
#           expect(response).to redirect_to edit_facilities_management_rm6232_building_path(building.id, section: 'security_type')
#         end

#         it 'does no update the unpermitted attribute' do
#           expect { building.reload }.not_to change(building, :building_name)
#         end
#       end
#     end

#     context 'when updating the security type' do
#       let(:section_name) { 'security_type' }

#       context 'and the data is valid' do
#         let(:update_params) { { security_type: 'Counter terrorist check (CTC)' } }

#         it 'redirects to the show page' do
#           expect(response).to redirect_to facilities_management_rm6232_building_path(building)
#         end

#         it 'updates the building type' do
#           expect do
#             building.reload
#           end.to(
#             change(building, :security_type).to('Counter terrorist check (CTC)')
#           )
#         end
#       end

#       context 'and the data is not valid' do
#         let(:update_params) { { security_type: '' } }

#         it 'renders the edit page' do
#           expect(response).to render_template(:edit)
#         end

#         it 'does not update the building type' do
#           RSpec::Matchers.define_negated_matcher :not_change, :change

#           expect do
#             building.reload
#           end.to(
#             not_change(building, :security_type)
#           )
#         end

#         it 'has correct backlink text and destination' do
#           expect(assigns(:back_text)).to eq 'Return to building type'
#           expect(assigns(:back_path)).to eq edit_facilities_management_rm6232_building_path(building.id, section: 'building_type')
#         end
#       end

#       context 'and an unpermitted parameters are passed in' do
#         let(:update_params) { { building_name: 'New building name', security_type: 'Counter terrorist check (CTC)' } }

#         it 'redirects to the show page' do
#           expect(response).to redirect_to facilities_management_rm6232_building_path(building)
#         end

#         it 'does no update the unpermitted attribute' do
#           expect { building.reload }.not_to change(building, :building_name)
#         end
#       end
#     end
#   end
#   # rubocop:enable RSpec/NestedGroups
# end
