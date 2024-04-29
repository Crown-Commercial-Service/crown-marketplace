def stub_cognito(option, roles)
  @user_email = Faker::Internet.unique.email

  aws_client = instance_double(Aws::CognitoIdentityProvider::Client)
  allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)

  method = :"stub_#{option}"

  send(
    method,
    aws_client,
    {
      user_email: @user_email,
      user_cognito_uuid: SecureRandom.uuid,
      roles: roles
    }
  )
end

def stub_cognito_with_error(option, error_key, roles = [])
  @user_email = Faker::Internet.unique.email

  aws_client = instance_double(Aws::CognitoIdentityProvider::Client)
  allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
  allow_any_instance_of(Cognito::SignInUser).to receive(:sleep)

  method = :"stub_#{option}_error"

  send(
    method,
    aws_client,
    {
      user_email: @user_email,
      user_cognito_uuid: SecureRandom.uuid,
      roles: roles
    },
    get_aws_error(error_key)
  )
end

def get_aws_error(error_key)
  "Aws::CognitoIdentityProvider::Errors::#{AWS_ERRORS[error_key]}".constantize.new('Some error', "An error occured: #{error_key}")
end

AWS_ERRORS = {
  'service' => 'ServiceError',
  'user not found' => 'UserNotFoundException',
  'invalid parameter' => 'InvalidParameterException',
  'username exists' => 'UsernameExistsException',
  'not authorized' => 'NotAuthorizedException',
  'code mismatch' => 'CodeMismatchException'
}.freeze

# Normal cognito paths
def stub_existing_user(aws_client, user_params)
  create(:user, :without_detail, email: user_params[:user_email], cognito_uuid: user_params[:user_cognito_uuid], confirmed_at: Time.zone.now, roles: user_params[:roles])
  allow(aws_client).to receive(:initiate_auth).and_return(COGNITO_RESPONSE_STRUCTS[:initiate_auth].new)
  stub_adding_to_groups(aws_client, user_params)
end

def stub_first_time_password_reset(aws_client, user_params)
  user_params[:session_uuid] = SecureRandom.uuid

  stub_login_with_challange(aws_client, user_params, 'NEW_PASSWORD_REQUIRED')

  allow(aws_client).to receive(:respond_to_auth_challenge).with(**respond_to_auth_challenge_new_password(user_params)).and_return(COGNITO_RESPONSE_STRUCTS[:respond_to_auth_challenge].new)
end

def stub_first_time_sms_mfa(aws_client, user_params)
  user_params[:session_uuid] = SecureRandom.uuid

  stub_login_with_challange(aws_client, user_params, 'NEW_PASSWORD_REQUIRED')

  allow(aws_client).to receive(:respond_to_auth_challenge).with(**respond_to_auth_challenge_new_password(user_params)).and_return(
    COGNITO_RESPONSE_STRUCTS[:respond_to_auth_challenge].new(
      session: user_params[:session_uuid],
      challenge_name: 'SMS_MFA'
    )
  )

  allow(aws_client).to receive(:respond_to_auth_challenge).with(**respond_to_auth_challenge_sms_mfa(user_params)).and_return(COGNITO_RESPONSE_STRUCTS[:respond_to_auth_challenge].new)
end

def stub_first_time_confirm_account(aws_client, user_params)
  create(:user, :without_detail, email: user_params[:user_email], cognito_uuid: user_params[:user_cognito_uuid], confirmed_at: Time.zone.now, roles: user_params[:roles])

  allow(aws_client).to receive(:initiate_auth).with(**initiate_auth(user_params)).and_raise(Aws::CognitoIdentityProvider::Errors::UserNotConfirmedException.new('Some error', 'Some message'))

  allow(aws_client).to receive(:confirm_sign_up).with(**confirm_sign_up(user_params))
end

def stub_sms_mfa(aws_client, user_params)
  user_params[:session_uuid] = SecureRandom.uuid

  stub_login_with_challange(aws_client, user_params, 'SMS_MFA')

  allow(aws_client).to receive(:respond_to_auth_challenge).with(**respond_to_auth_challenge_sms_mfa(user_params)).and_return(COGNITO_RESPONSE_STRUCTS[:respond_to_auth_challenge].new)
end

def stub_password_reset_required(aws_client, user_params)
  create(:user, :without_detail, email: user_params[:user_email], cognito_uuid: user_params[:user_cognito_uuid], confirmed_at: Time.zone.now, roles: user_params[:roles])

  allow(aws_client).to receive(:initiate_auth).with(**initiate_auth(user_params)).and_raise(Aws::CognitoIdentityProvider::Errors::PasswordResetRequiredException.new('Some error', 'Some message'))

  allow(aws_client).to receive(:confirm_forgot_password).with(**confirm_forgot_password(user_params))
end

def stub_forgot_password(aws_client, user_params)
  create(:user, :without_detail, email: user_params[:user_email], cognito_uuid: user_params[:user_cognito_uuid], confirmed_at: Time.zone.now, roles: user_params[:roles])

  allow(aws_client).to receive(:forgot_password).with(**forgot_password(user_params))

  allow(aws_client).to receive(:confirm_forgot_password).with(**confirm_forgot_password(user_params))
end

def stub_create_an_account(aws_client, user_params)
  user_params[:user_email] = Faker::Internet.email(domain: 'test.com')
  @user_email = user_params[:user_email]

  allow(aws_client).to receive(:sign_up).with(**sign_up(user_params)).and_return(
    {
      'user_sub' => user_params[:user_cognito_uuid]
    }
  )

  user_params[:roles].each do |role|
    allow(aws_client).to receive(:admin_add_user_to_group).with(
      user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
      username: user_params[:user_cognito_uuid],
      group_name: role
    )
  end

  allow(aws_client).to receive(:confirm_sign_up).with(**confirm_sign_up(user_params))
end

# Cognito paths with errors
def stub_forgot_password_error(aws_client, user_params, error)
  allow(aws_client).to receive(:forgot_password).with(**forgot_password(user_params)).and_raise(error)
end

def stub_create_an_account_error(aws_client, user_params, error)
  user_params[:user_email] = Faker::Internet.email(domain: 'test.com')
  @user_email = user_params[:user_email]

  allow(aws_client).to receive(:sign_up).with(**sign_up(user_params)).and_raise(error)
end

def stub_sign_in_error(aws_client, user_params, error)
  allow(aws_client).to receive(:initiate_auth).with(**initiate_auth(user_params)).and_raise(error)
end

def stub_sms_mfa_error(aws_client, user_params, error)
  user_params[:session_uuid] = SecureRandom.uuid

  stub_login_with_challange(aws_client, user_params, 'SMS_MFA')

  allow(aws_client).to receive(:respond_to_auth_challenge).with(**respond_to_auth_challenge_sms_mfa(user_params)).and_raise(error)
end

def stub_first_time_password_reset_error(aws_client, user_params, error)
  user_params[:session_uuid] = SecureRandom.uuid

  stub_login_with_challange(aws_client, user_params, 'NEW_PASSWORD_REQUIRED')

  allow(aws_client).to receive(:respond_to_auth_challenge).with(**respond_to_auth_challenge_new_password(user_params)).and_raise(error)
end

def stub_first_time_sms_mfa_error(aws_client, user_params, error)
  user_params[:session_uuid] = SecureRandom.uuid

  stub_login_with_challange(aws_client, user_params, 'NEW_PASSWORD_REQUIRED')

  allow(aws_client).to receive(:respond_to_auth_challenge).with(**respond_to_auth_challenge_new_password(user_params)).and_return(
    COGNITO_RESPONSE_STRUCTS[:respond_to_auth_challenge].new(
      session: user_params[:session_uuid],
      challenge_name: 'SMS_MFA'
    )
  )

  allow(aws_client).to receive(:respond_to_auth_challenge).with(**respond_to_auth_challenge_sms_mfa(user_params)).and_raise(error)
end

def stub_first_time_confirm_account_error(aws_client, user_params, error)
  create(:user, :without_detail, email: user_params[:user_email], cognito_uuid: user_params[:user_cognito_uuid], confirmed_at: Time.zone.now, roles: user_params[:roles])

  allow(aws_client).to receive(:initiate_auth).with(**initiate_auth(user_params)).and_raise(Aws::CognitoIdentityProvider::Errors::UserNotConfirmedException.new('Some error', 'Some message'))

  allow(aws_client).to receive(:confirm_sign_up).with(**confirm_sign_up(user_params)).and_raise(error)
end

def stub_password_reset_required_error(aws_client, user_params, error)
  create(:user, :without_detail, email: user_params[:user_email], cognito_uuid: user_params[:user_cognito_uuid], confirmed_at: Time.zone.now, roles: user_params[:roles])

  allow(aws_client).to receive(:initiate_auth).with(**initiate_auth(user_params)).and_raise(Aws::CognitoIdentityProvider::Errors::PasswordResetRequiredException.new('Some error', 'Some message'))

  allow(aws_client).to receive(:confirm_forgot_password).with(**confirm_forgot_password(user_params)).and_raise(error)
end

# Shared methods
def stub_login_with_challange(aws_client, user_params, challenge)
  allow(aws_client).to receive(:initiate_auth).with(**initiate_auth(user_params)).and_return(
    COGNITO_RESPONSE_STRUCTS[:initiate_auth].new(
      session: user_params[:session_uuid],
      challenge_parameters: {
        'USER_ID_FOR_SRP' => user_params[:user_cognito_uuid]
      },
      challenge_name: challenge
    )
  )

  allow(aws_client).to receive(:admin_get_user).with(**admin_get_user(user_params)).and_return(
    COGNITO_RESPONSE_STRUCTS[:admin_get_user].new(
      user_attributes: [
        COGNITO_OBJECT_STRUCTS[:cognito_user_attribute].new(name: 'sub', value: user_params[:user_cognito_uuid]),
        COGNITO_OBJECT_STRUCTS[:cognito_user_attribute].new(name: 'email', value: user_params[:user_email])
      ]
    )
  )

  stub_adding_to_groups(aws_client, user_params)
end

def stub_adding_to_groups(aws_client, user_params)
  allow(aws_client).to receive(:admin_list_groups_for_user).with(**admin_get_user(user_params)).and_return(
    COGNITO_RESPONSE_STRUCTS[:admin_list_groups_for_user].new(
      groups: user_params[:roles].map { |role| COGNITO_OBJECT_STRUCTS[:cognito_group].new(group_name: role) }
    )
  )
end

# Methods which build the params
def initiate_auth(user_params)
  {
    client_id: ENV.fetch('COGNITO_CLIENT_ID', nil),
    auth_flow: 'USER_PASSWORD_AUTH',
    auth_parameters: {
      'USERNAME' => user_params[:user_email],
      'PASSWORD' => 'ValidPassword'
    }
  }
end

def respond_to_auth_challenge_new_password(user_params)
  {
    client_id: ENV.fetch('COGNITO_CLIENT_ID', nil),
    session: user_params[:session_uuid],
    challenge_name: 'NEW_PASSWORD_REQUIRED',
    challenge_responses: {
      'NEW_PASSWORD' => 'ValidPassword1!',
      'USERNAME' => user_params[:user_cognito_uuid]
    }
  }
end

def respond_to_auth_challenge_sms_mfa(user_params)
  {
    client_id: ENV.fetch('COGNITO_CLIENT_ID', nil),
    session: user_params[:session_uuid],
    challenge_name: 'SMS_MFA',
    challenge_responses: {
      'SMS_MFA_CODE' => '123456',
      'USERNAME' => user_params[:user_cognito_uuid]
    }
  }
end

def confirm_sign_up(user_params)
  {
    confirmation_code: '123456'
  }.merge(forgot_password(user_params))
end

def confirm_forgot_password(user_params)
  {
    password: 'ValidPassword1!',
    confirmation_code: '123456'
  }.merge(forgot_password(user_params))
end

def forgot_password(user_params)
  {
    client_id: ENV.fetch('COGNITO_CLIENT_ID', nil),
    username: user_params[:user_email]
  }
end

def sign_up(user_params)
  {
    password: 'ValidPassword1!',
    user_attributes: [
      {
        name: 'email',
        value: user_params[:user_email]
      }
    ]
  }.merge(forgot_password(user_params))
end

def admin_get_user(user_params)
  {
    user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
    username: user_params[:user_cognito_uuid]
  }
end
