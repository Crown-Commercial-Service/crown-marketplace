def stub_login
  Aws.config[:cognitoidentityprovider] = {
    stub_responses: {
      admin_get_user: {
        username: @user.email,
        user_attributes: [
          { name: 'sub', value: SecureRandom.uuid },
          { name: 'email', value: @user.email },
        ],
        user_status: 'CONFIRMED'
      },
      admin_list_groups_for_user: {
        groups: @user.roles.map { |role| { group_name: role.to_s } }
      },
      initiate_auth: {
        authentication_result: {
          access_token: 'mock_access_token',
          id_token: 'mock_id_token',
          refresh_token: 'mock_refresh_token'
        }
      }
    }
  }

  allow_any_instance_of(Cognito::SignInUser).to receive(:sleep)
end

def create_user_with_details
  create_user(:with_detail)
  stub_login
end

def create_user_without_details
  create_user(:without_detail)
  stub_login
end

def create_admin_user_with_details
  @user = create(:user, :with_detail, confirmed_at: Time.zone.now, roles: %i[buyer ccs_employee fm_access supplier])
  allow_any_instance_of(Cognito::UpdateUser).to receive(:call).and_return(true)
  allow_any_instance_of(Cognito::UpdateUser).to receive(:call).with(anything).and_return(true)
  stub_login
end

def create_user(option)
  @user = create(:user, option, confirmed_at: Time.zone.now, roles: %i[buyer fm_access])
  allow_any_instance_of(Cognito::UpdateUser).to receive(:call).and_return(true)
  allow_any_instance_of(Cognito::UpdateUser).to receive(:call).with(anything).and_return(true)
  stub_login
end

def create_admin_user(user_type)
  @user = create(:user, confirmed_at: Time.zone.now, roles: [USER_TYPE_TO_ROLE[user_type]])
  allow_any_instance_of(Cognito::UpdateUser).to receive(:call).and_return(true)
  allow_any_instance_of(Cognito::UpdateUser).to receive(:call).with(anything).and_return(true)
  stub_login
end

USER_TYPE_TO_ROLE = {
  'user support' => :allow_list_access,
  'user admin' => :ccs_user_admin,
  'super admin' => :ccs_developer
}.freeze
