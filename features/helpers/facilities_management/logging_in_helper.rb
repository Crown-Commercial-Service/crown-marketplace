def stub_login
  aws_client = instance_double(Aws::CognitoIdentityProvider::Client)
  allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
  allow(aws_client).to receive(:initiate_auth).and_return(COGNITO_RESPONSE_STRUCTS[:initiate_auth].new)
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
