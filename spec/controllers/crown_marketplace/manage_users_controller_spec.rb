require 'rails_helper'

RSpec.describe CrownMarketplace::ManageUsersController do
  include_context 'with cognito structs'

  let(:default_params) { { service: 'crown_marketplace' } }

  let(:user) { Cognito::Admin::User.new(current_user_access, attributes) }

  let(:current_user_access) { :super_admin }
  let(:cognito_uuid) { SecureRandom.uuid }
  let(:email) { 'user@crowncommercial.gov.uk' }
  let(:account_status) { true }
  let(:roles) { %w[buyer] }
  let(:telephone_number) { '07123456789' }
  let(:service_access) { %w[fm_access] }
  let(:mfa_enabled) { false }

  let(:attributes) do
    {
      cognito_uuid: cognito_uuid,
      email: email,
      telephone_number: telephone_number,
      roles: roles,
      service_access: service_access,
      account_status: account_status,
      confirmation_status: 'CONFIRMED',
      mfa_enabled: mfa_enabled
    }
  end

  describe 'callbacks' do
    context 'when I log in as a buyer' do
      login_fm_buyer

      it 'redirects to the not permited path' do
        get :new

        expect(response).to redirect_to '/crown-marketplace/not-permitted'
      end
    end

    context 'when I log in as a supplier' do
      login_fm_supplier

      it 'redirects to the not permited path' do
        get :new

        expect(response).to redirect_to '/crown-marketplace/not-permitted'
      end
    end

    context 'when I log in as a service admin' do
      login_fm_admin

      it 'redirects to the not permited path' do
        get :new

        expect(response).to redirect_to '/crown-marketplace/not-permitted'
      end
    end

    context 'when I log in as a user support admin' do
      login_user_support_admin

      before { get :new }

      it 'renders the new page' do
        expect(response).to render_template(:new)
      end

      it 'sets the current user access to user_support' do
        expect(assigns(:current_user_access)).to eq :user_support
      end
    end

    context 'when I log in as a user admin' do
      login_user_admin

      before { get :new }

      it 'renders the new page' do
        expect(response).to render_template(:new)
      end

      it 'sets the current user access to user_admin' do
        expect(assigns(:current_user_access)).to eq :user_admin
      end
    end

    context 'when I log in as a super admin' do
      login_super_admin

      before { get :new }

      it 'renders the new page' do
        expect(response).to render_template(:new)
      end

      it 'sets the current user access to super_admin' do
        expect(assigns(:current_user_access)).to eq :super_admin
      end
    end
  end

  describe 'GET index' do
    login_super_admin

    context 'when there is no email' do
      before { get :index }

      it 'renders the index page' do
        expect(response).to render_template(:index)
      end

      it 'has an empty search' do
        expect(assigns(:search)).to eq({ users: [] })
      end
    end

    context 'when an email is provided' do
      let(:found_user_1) { { cognito_uuid: SecureRandom.uuid, email: 'test1@test.com', account_status: true } }
      let(:found_user_2) { { cognito_uuid: SecureRandom.uuid, email: 'test2@test.com', account_status: false } }

      before do
        aws_client = instance_double(Aws::CognitoIdentityProvider::Client)

        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:list_users).with(
          {
            user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
            attributes_to_get: ['email'],
            filter: 'email ^= "test"'
          }
        ).and_return(
          list_users_resp_struct.new(
            users: [
              found_user_1,
              found_user_2
            ].map { |found_user| cognito_user_struct.new(username: found_user[:cognito_uuid], enabled: found_user[:account_status], attributes: [cognito_user_attribute_struct.new(name: 'email', value: found_user[:email])]) }
          )
        )
        get :index, params: { email: 'test' }
      end

      it 'renders the index page' do
        expect(response).to render_template(:index)
      end

      it 'has a search with the users response' do
        expect(assigns(:search)).to eq(
          {
            users: [
              found_user_1,
              found_user_2
            ]
          }
        )
      end
    end

    context 'when the email is blank' do
      before { get :index, params: { email: '' } }

      it 'renders the index page' do
        expect(response).to render_template(:index)
      end

      it 'has a search with the error in the response' do
        expect(assigns(:search)).to eq(
          {
            users: [],
            error: 'You must enter an email address'
          }
        )
      end
    end
  end

  describe 'POST search_users' do
    login_super_admin

    context 'when there is no email' do
      before { post :search_users }

      it 'renders the index page' do
        expect(response).to render_template(:index)
      end

      it 'has an empty search' do
        expect(assigns(:search)).to eq({ users: [] })
      end
    end

    context 'when an email is provided' do
      let(:found_user_1) { { cognito_uuid: SecureRandom.uuid, email: 'test1@test.com', account_status: true } }
      let(:found_user_2) { { cognito_uuid: SecureRandom.uuid, email: 'test2@test.com', account_status: false } }

      before do
        aws_client = instance_double(Aws::CognitoIdentityProvider::Client)

        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:list_users).with(
          {
            user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
            attributes_to_get: ['email'],
            filter: 'email ^= "test"'
          }
        ).and_return(
          list_users_resp_struct.new(
            users: [
              found_user_1,
              found_user_2
            ].map { |found_user| cognito_user_struct.new(username: found_user[:cognito_uuid], enabled: found_user[:account_status], attributes: [cognito_user_attribute_struct.new(name: 'email', value: found_user[:email])]) }
          )
        )
      end

      context 'and it is a HTML request' do
        before { post :search_users, params: { email: 'test' } }

        it 'renders the index page' do
          expect(response).to render_template(:index)
        end

        it 'has a search with the users response' do
          expect(assigns(:search)).to eq(
            {
              users: [
                found_user_1,
                found_user_2
              ]
            }
          )
        end
      end

      context 'and it is a JSON request' do
        before { post :search_users, params: { email: 'test' }, as: :json }

        it 'renders the _users_table partial' do
          expect(response).to render_template('crown_marketplace/manage_users/_users_table')
        end

        it 'renders the json with the expected keys' do
          expect(response.content_type).to eq('application/json; charset=utf-8')

          expect(response.parsed_body['html'].is_a?(String)).to be true
          expect(response.parsed_body['error_message_html']).to be_nil
        end

        it 'has a search with the users response' do
          expect(assigns(:search)).to eq(
            {
              users: [
                found_user_1,
                found_user_2
              ]
            }
          )
        end
      end
    end

    context 'when the email is blank' do
      context 'and it is a HTML request' do
        before { get :index, params: { email: '' } }

        it 'renders the index page' do
          expect(response).to render_template(:index)
        end

        it 'has a search with the error in the response' do
          expect(assigns(:search)).to eq(
            {
              users: [],
              error: 'You must enter an email address'
            }
          )
        end
      end

      context 'and it is a JSON request' do
        before { post :search_users, params: { email: '' }, as: :json }

        it 'renders the _users_table partial' do
          expect(response).to render_template('crown_marketplace/manage_users/_users_table')
        end

        it 'renders the json with the expected keys' do
          expect(response.content_type).to eq('application/json; charset=utf-8')

          expect(response.parsed_body['html'].is_a?(String)).to be true
          expect(response.parsed_body['error_message_html'].is_a?(String)).to be true
        end

        it 'has a search with the error in the response' do
          expect(assigns(:search)).to eq(
            {
              users: [],
              error: 'You must enter an email address'
            }
          )
        end
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe 'GET add_user' do
    context 'and I am a super admin' do
      let(:additional_params) { {} }

      login_super_admin

      before { get :add_user, params: { section:, **additional_params } }

      context 'and the section is select-role' do
        let(:section) { 'select-role' }

        it 'sets the user' do
          expect(assigns(:user)).to be_present
        end

        context 'and we render the template' do
          render_views

          it 'renders the select_role template' do
            expect(response).to render_template(partial: 'crown_marketplace/manage_users/add_user_partials/_select_role')
          end
        end

        context 'and additional params are passed' do
          let(:additional_params) { { roles: ['buyer'], service_access: ['fm_access'] } }

          it 'sets the user with the data from the params' do
            expect(assigns(:user).roles).to eq ['buyer']
            expect(assigns(:user).service_access).to eq ['fm_access']
          end
        end
      end

      context 'and the section is select-service-access' do
        let(:additional_params) { { roles: ['buyer'] } }
        let(:section) { 'select-service-access' }

        it 'sets the user with the roles' do
          expect(assigns(:user)).to be_present
          expect(assigns(:user).roles).to eq ['buyer']
        end

        context 'and we render the template' do
          render_views

          it 'renders the select_service_access template' do
            expect(response).to render_template(partial: 'crown_marketplace/manage_users/add_user_partials/_select_service_access')
          end
        end

        context 'and additional params are passed' do
          let(:additional_params) { super().merge({ service_access: ['fm_access'], email: 'example@email.com' }) }

          it 'sets the user with the data from the params' do
            expect(assigns(:user).service_access).to eq ['fm_access']
            expect(assigns(:user).email).to eq 'example@email.com'
          end
        end

        context 'and the role does not require service access' do
          let(:additional_params) { { roles: ['allow_list_access'] } }

          it 'redirects to the select enter user details section with the current params' do
            expect(response).to redirect_to(add_user_crown_marketplace_manage_users_path(section: 'enter-user-details', roles: ['allow_list_access']))
          end
        end
      end

      context 'and the section is enter-user-details' do
        let(:additional_params) { { roles: ['buyer'], service_access: ['fm_access'] } }
        let(:section) { 'enter-user-details' }

        it 'sets the user with the roles and service access' do
          expect(assigns(:user)).to be_present
          expect(assigns(:user).roles).to eq ['buyer']
          expect(assigns(:user).service_access).to eq ['fm_access']
        end

        context 'and we render the template' do
          render_views

          it 'renders the select_service_access template' do
            expect(response).to render_template(partial: 'crown_marketplace/manage_users/add_user_partials/_enter_user_details')
          end
        end

        context 'and additional params are passed' do
          let(:additional_params) { super().merge({ email: 'example@email.com', telephone_number: '07123456789' }) }

          it 'sets the user with the data from the params' do
            expect(assigns(:user).email).to eq 'example@email.com'
            expect(assigns(:user).telephone_number).to eq '07123456789'
          end
        end
      end
    end

    context 'and I am a user support admin and I go to the select role page' do
      login_user_support_admin

      before { get :add_user, params: { section: 'select-role' } }

      it 'redirects to the select service access section with the role as buyer' do
        expect(response).to redirect_to(add_user_crown_marketplace_manage_users_path(section: 'select-service-access', roles: ['buyer']))
      end
    end
  end

  describe 'POST create_add_user' do
    context 'and I am a super admin' do
      let(:create_add_user_params) { {} }

      login_super_admin

      before do
        aws_client = instance_double(Aws::CognitoIdentityProvider::Client)

        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:list_users).and_return(list_users_resp_struct.new(users: []))

        post :create_add_user, params: { section: section, cognito_admin_user: create_add_user_params }
      end

      context 'and the section is select-role' do
        let(:section) { 'select-role' }
        let(:create_add_user_params) { { roles: } }

        context 'and the data is valid' do
          let(:roles) { ['buyer'] }

          it 'redirects to the edit user details section with the role as a param' do
            expect(response).to redirect_to(add_user_crown_marketplace_manage_users_path(section: 'select-service-access', roles: ['buyer']))
          end
        end

        context 'and the data is invalid' do
          let(:roles) { [] }

          it 'renders the add_user page' do
            expect(response).to render_template(:add_user)
          end
        end
      end

      context 'and the section is select-service-access' do
        let(:section) { 'select-service-access' }
        let(:create_add_user_params) { { roles: ['buyer'], service_access: service_access } }

        context 'and the data is valid' do
          let(:service_access) { ['fm_access'] }

          it 'redirects to the edit user details section with the role and service access as a param' do
            expect(response).to redirect_to(add_user_crown_marketplace_manage_users_path(section: 'enter-user-details', roles: ['buyer'], service_access: ['fm_access']))
          end
        end

        context 'and the data is invalid' do
          let(:service_access) { [] }

          it 'renders the add_user page' do
            expect(response).to render_template(:add_user)
          end
        end
      end

      context 'and the section is enter-user-details' do
        let(:section) { 'enter-user-details' }
        let(:create_add_user_params) { { roles: ['buyer'], service_access: ['fm_access'], email: email } }

        context 'and the data is valid' do
          let(:email) { 'email@email.com' }

          it 'redirects to the new page with the role, service access and email as a param' do
            expect(response).to redirect_to(new_crown_marketplace_manage_user_path(roles: ['buyer'], service_access: ['fm_access'], email: 'email@email.com'))
          end
        end

        context 'and the data is invalid' do
          let(:email) { nil }

          it 'renders the add_user page' do
            expect(response).to render_template(:add_user)
          end
        end
      end
    end

    context 'and I am a user support admin and I go to the select role page' do
      login_user_support_admin

      before { post :create_add_user, params: { section: 'select-role' } }

      it 'redirects to the select service access section with the role as buyer' do
        expect(response).to redirect_to(add_user_crown_marketplace_manage_users_path(section: 'select-service-access', roles: ['buyer']))
      end
    end
  end

  describe 'GET new' do
    login_super_admin

    before { get :new, params: { roles: ['buyer'], service_access: ['fm_access'], email: 'example@email.com' } }

    # rubocop:disable RSpec/MultipleExpectations
    it 'sets the user with the roles, service access and email' do
      expect(assigns(:user)).to be_present
      expect(assigns(:user).roles).to eq ['buyer']
      expect(assigns(:user).service_access).to eq ['fm_access']
      expect(assigns(:user).email).to eq 'example@email.com'
    end
    # rubocop:enable RSpec/MultipleExpectations

    it 'renders the new page' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

    login_super_admin

    before { allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client) }

    context 'when the user is successfully created' do
      before do
        allow(aws_client).to receive(:admin_create_user).and_return(admin_create_user_resp_struct.new(user: { 'username' => SecureRandom.uuid }))
        allow(aws_client).to receive(:admin_add_user_to_group)

        post :create, params: { cognito_admin_user: { roles: ['buyer'], service_access: ['fm_access'], email: 'example@email.com' } }
      end

      it 'redirects to the crown marketplace home page and sets the flash message' do
        expect(response).to redirect_to crown_marketplace_path
        expect(flash[:account_added]).to eq 'example@email.com'
      end
    end

    context 'when there is an issue creating the user' do
      before do
        allow(aws_client).to receive(:admin_create_user).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('Some context', 'Some message'))

        post :create, params: { cognito_admin_user: { roles: ['buyer'], service_access: ['fm_access'], email: 'example@email.com' } }
      end

      it 'renders the new page' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET show' do
    login_super_admin

    before do
      allow(Cognito::Admin::User).to receive(:find).and_return(user)

      get :show, params: { cognito_uuid: }
    end

    context 'when the current user has edit permissions and successfully looks up a user' do
      it 'renders the show page' do
        expect(response).to render_template(:show)
      end

      it 'sets the @minimum_editor instance variable correctly' do
        expect(assigns(:minimum_editor)).to eq('allow_list_access')
      end
    end

    context 'when current user does not have edit permissions and successfully looks up a user' do
      login_user_support_admin

      let(:current_user_access) { :user_support }
      let(:roles) { %w[ccs_user_admin] }

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end

      it 'sets the @minimum_editor instance variable correctly' do
        expect(assigns(:minimum_editor)).to eq('ccs_developer')
      end
    end

    context 'when there is an error on the user' do
      let(:user) { Cognito::Admin::User.new(current_user_access, attributes) }
      let(:current_user_access) { :super_admin }
      let(:attributes) { super().merge({ error: 'error_message' }) }

      it 'redirects to the crown marketplace home page' do
        expect(response).to redirect_to crown_marketplace_path
      end
    end
  end

  describe 'GET edit' do
    context 'when there is an issue with editing the user' do
      before { allow(Cognito::Admin::User).to receive(:find).and_return(user) }

      context 'and it is because I do not have permissions to edit the user' do
        let(:roles) { %w[ccs_developer] }

        login_super_admin

        before { get :edit, params: { cognito_uuid: cognito_uuid, section: :service_access } }

        it 'redirects to the crown marketplace home page and sets the flash message' do
          expect(response).to redirect_to crown_marketplace_path
          expect(flash[:error_message]).to eq 'You do not have the required permissions to edit this user'
        end
      end

      context 'and it is because I try and edit a section that does not exist' do
        login_super_admin

        before { get :edit, params: { cognito_uuid: cognito_uuid, section: :bank_account } }

        it 'redirects to the show page' do
          expect(response).to redirect_to crown_marketplace_manage_user_path(cognito_uuid:)
        end
      end

      context 'and it is because I try and edit a section that does not exist for my user type' do
        %i[telephone_number mfa_enabled roles].each do |unpermitted_section|
          login_user_support_admin

          before { get :edit, params: { cognito_uuid: cognito_uuid, section: unpermitted_section } }

          it "redirects to the show page for #{unpermitted_section}" do
            expect(response).to redirect_to crown_marketplace_manage_user_path(cognito_uuid:)
          end
        end
      end
    end

    context 'when there is no issue with editing the user' do
      login_super_admin

      render_views

      before do
        allow(Cognito::Admin::User).to receive(:find).and_return(user)

        get :edit, params: { cognito_uuid:, section: }
      end

      context 'and I edit the users email_verified' do
        let(:section) { :email_verified }

        it 'sets the user' do
          expect(assigns(:user)).to eq user
        end

        it 'renders the email_verified template' do
          expect(response).to render_template(partial: 'crown_marketplace/manage_users/edit_partials/_email_verified')
        end
      end

      context 'and I edit the users account_status' do
        let(:section) { :account_status }

        it 'sets the user' do
          expect(assigns(:user)).to eq user
        end

        it 'renders the account_status template' do
          expect(response).to render_template(partial: 'crown_marketplace/manage_users/edit_partials/_account_status')
        end
      end

      context 'and I edit the users telephone_number' do
        let(:section) { :telephone_number }

        it 'sets the user' do
          expect(assigns(:user)).to eq user
        end

        it 'renders the telephone_number template' do
          expect(response).to render_template(partial: 'crown_marketplace/manage_users/edit_partials/_telephone_number')
        end
      end

      context 'and I edit the users mfa_enabled' do
        let(:section) { :mfa_enabled }

        it 'sets the user' do
          expect(assigns(:user)).to eq user
        end

        it 'renders the mfa_enabled template' do
          expect(response).to render_template(partial: 'crown_marketplace/manage_users/edit_partials/_mfa_enabled')
        end
      end

      context 'and I edit the users roles' do
        let(:section) { :roles }

        it 'sets the user' do
          expect(assigns(:user)).to eq user
        end

        it 'renders the roles template' do
          expect(response).to render_template(partial: 'crown_marketplace/manage_users/edit_partials/_roles')
        end
      end

      context 'and I edit the users service_access' do
        let(:section) { :service_access }

        it 'sets the user' do
          expect(assigns(:user)).to eq user
        end

        it 'renders the service_access template' do
          expect(response).to render_template(partial: 'crown_marketplace/manage_users/edit_partials/_service_access')
        end
      end
    end
  end

  describe 'PUT update' do
    context 'when there is an issue with editing the user' do
      before { allow(Cognito::Admin::User).to receive(:find).and_return(user) }

      context 'and it is because I do not have permissions to edit the user' do
        let(:roles) { %w[ccs_developer] }

        login_super_admin

        before { put :update, params: { cognito_uuid: cognito_uuid, section: :service_access } }

        it 'redirects to the crown marketplace home page and sets the flash message' do
          expect(response).to redirect_to crown_marketplace_path
          expect(flash[:error_message]).to eq 'You do not have the required permissions to edit this user'
        end
      end

      context 'and it is because I try and update a section that does not exist' do
        login_super_admin

        before { put :update, params: { cognito_uuid: cognito_uuid, section: :bank_account } }

        it 'redirects to the show page' do
          expect(response).to redirect_to crown_marketplace_manage_user_path(cognito_uuid:)
        end
      end

      context 'and it is because I try and update a section that does not exist for my user type' do
        %i[telephone_number mfa_enabled roles].each do |unpermitted_section|
          login_user_support_admin

          before { put :update, params: { cognito_uuid: cognito_uuid, section: unpermitted_section } }

          it "redirects to the show page for #{unpermitted_section}" do
            expect(response).to redirect_to crown_marketplace_manage_user_path(cognito_uuid:)
          end
        end
      end
    end

    context 'when there is no issue with editing the user' do
      let(:is_valid) { false }
      let(:update_params) { nil }

      login_super_admin

      before do
        allow(Cognito::Admin::User).to receive(:find).and_return(user)
        allow(user).to receive(:update).with(section).and_return(is_valid)

        put :update, params: { cognito_uuid: cognito_uuid, section: section, cognito_admin_user: { section => update_params } }
      end

      context 'and I update email_verified for the user' do
        let(:section) { :email_verified }

        context 'and it is valid' do
          let(:is_valid) { true }
          let(:update_params) { true }

          it 'sets the user' do
            expect(assigns(:user)).to eq user
          end

          it 'redirects to the show page' do
            expect(response).to redirect_to crown_marketplace_manage_user_path(cognito_uuid:)
          end
        end

        context 'and it is invalid' do
          it 'sets the user' do
            expect(assigns(:user)).to eq user
          end

          it 'renders the edit template' do
            expect(response).to render_template(:edit)
          end
        end
      end

      context 'and I update account_status for the user' do
        let(:section) { :account_status }

        context 'and it is valid' do
          let(:is_valid) { true }
          let(:update_params) { true }

          it 'sets the user' do
            expect(assigns(:user)).to eq user
          end

          it 'redirects to the show page' do
            expect(response).to redirect_to crown_marketplace_manage_user_path(cognito_uuid:)
          end
        end

        context 'and it is invalid' do
          it 'sets the user' do
            expect(assigns(:user)).to eq user
          end

          it 'renders the edit template' do
            expect(response).to render_template(:edit)
          end
        end
      end

      context 'and I update telephone_number for the user' do
        let(:section) { :telephone_number }

        context 'and it is valid' do
          let(:is_valid) { true }
          let(:update_params) { telephone_number }

          it 'sets the user' do
            expect(assigns(:user)).to eq user
          end

          it 'redirects to the show page' do
            expect(response).to redirect_to crown_marketplace_manage_user_path(cognito_uuid:)
          end
        end

        context 'and it is invalid' do
          it 'sets the user' do
            expect(assigns(:user)).to eq user
          end

          it 'renders the edit template' do
            expect(response).to render_template(:edit)
          end
        end
      end

      context 'and I update mfa_enabled for the user' do
        let(:section) { :mfa_enabled }

        context 'and it is valid' do
          let(:is_valid) { true }
          let(:update_params) { mfa_enabled }

          it 'sets the user' do
            expect(assigns(:user)).to eq user
          end

          it 'redirects to the show page' do
            expect(response).to redirect_to crown_marketplace_manage_user_path(cognito_uuid:)
          end
        end

        context 'and it is invalid' do
          it 'sets the user' do
            expect(assigns(:user)).to eq user
          end

          it 'renders the edit template' do
            expect(response).to render_template(:edit)
          end
        end
      end

      context 'and I update roles for the user' do
        let(:section) { :roles }

        context 'and it is valid' do
          let(:is_valid) { true }
          let(:update_params) { roles }

          it 'sets the user' do
            expect(assigns(:user)).to eq user
          end

          it 'redirects to the show page' do
            expect(response).to redirect_to crown_marketplace_manage_user_path(cognito_uuid:)
          end
        end

        context 'and it is invalid' do
          it 'sets the user' do
            expect(assigns(:user)).to eq user
          end

          it 'renders the edit template' do
            expect(response).to render_template(:edit)
          end
        end
      end

      context 'and I update service_access for the user' do
        let(:section) { :service_access }

        context 'and it is valid' do
          let(:is_valid) { true }
          let(:update_params) { service_access }

          it 'sets the user' do
            expect(assigns(:user)).to eq user
          end

          it 'redirects to the show page' do
            expect(response).to redirect_to crown_marketplace_manage_user_path(cognito_uuid:)
          end
        end

        context 'and it is invalid' do
          it 'sets the user' do
            expect(assigns(:user)).to eq user
          end

          it 'renders the edit template' do
            expect(response).to render_template(:edit)
          end
        end
      end
    end
  end

  describe 'PUT resend_temporary_password' do
    before { allow(Cognito::Admin::User).to receive(:find).and_return(user) }

    context 'when I do not have permissions to edit the user' do
      let(:roles) { %w[ccs_developer] }

      login_super_admin

      before { put :resend_temporary_password, params: { cognito_uuid: } }

      it 'redirects to the crown marketplace home page and sets the flash message' do
        expect(response).to redirect_to crown_marketplace_path
        expect(flash[:error_message]).to eq 'You do not have the required permissions to edit this user'
      end
    end

    context 'when I am allowed to edit the user' do
      login_super_admin

      before do
        allow(user).to receive(:resend_temporary_password).and_return(resend_temporary_password_response)

        put :resend_temporary_password, params: { cognito_uuid: }
      end

      context 'and there is an error' do
        let(:resend_temporary_password_response) { 'There was an error' }

        it 'sets the user' do
          expect(assigns(:user)).to eq user
        end

        it 'redirects to the crown marketplace manage users show page and sets the flash error message' do
          expect(response).to redirect_to crown_marketplace_manage_user_path
          expect(flash[:error_message]).to eq 'There was an error'
        end
      end

      context 'and there is no error' do
        let(:resend_temporary_password_response) { nil }

        it 'sets the user' do
          expect(assigns(:user)).to eq user
        end

        it 'redirects to the crown marketplace manage users show page and sets the flash password resent message' do
          expect(response).to redirect_to crown_marketplace_manage_user_path
          expect(flash[:password_resent]).to eq email
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
