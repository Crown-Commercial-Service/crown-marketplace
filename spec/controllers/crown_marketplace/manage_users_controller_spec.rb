require 'rails_helper'

RSpec.describe CrownMarketplace::ManageUsersController, type: :controller do
  let(:default_params) { { service: 'crown_marketplace' } }

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

  # rubocop:disable RSpec/NestedGroups
  describe 'GET add_user' do
    context 'and I am a super admin' do
      let(:additional_params) { {} }

      login_super_admin

      before { get :add_user, params: { section: section, **additional_params } }

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
        allow(aws_client).to receive(:list_users).and_return(OpenStruct.new(users: []))

        post :create_add_user, params: { section: section, cognito_admin_user: create_add_user_params }
      end

      context 'and the section is select-role' do
        let(:section) { 'select-role' }
        let(:create_add_user_params) { { roles: roles } }

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
        allow(aws_client).to receive(:admin_create_user).and_return(OpenStruct.new(user: { 'username' => SecureRandom.uuid }))
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
  # rubocop:enable RSpec/NestedGroups
end
