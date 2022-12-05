def stub_admin_cognito(option, **options)
  aws_client = instance_double(Aws::CognitoIdentityProvider::Client)
  allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)

  method = "stub_#{option}".to_sym

  send(
    method,
    aws_client,
    **options
  )
end

def stub_cognito_admin_with_error(option, error_key)
  aws_client = instance_double(Aws::CognitoIdentityProvider::Client)
  allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)

  method = "stub_#{option}_error".to_sym

  send(
    method,
    aws_client,
    get_aws_error(error_key)
  )
end

def stub_list_users(aws_client, **options)
  users = options[:resp_email] ? [options[:resp_email]] : []

  allow(aws_client).to receive(:list_users).with(**list_users_params(options[:search_email])).and_return(OpenStruct.new(users: users))
end

# rubocop:disable Metrics/AbcSize
def stub_create_user(aws_client, **options)
  cognito_uuid = SecureRandom.uuid

  allow(aws_client).to receive(:admin_create_user).with(**create_user_params(options[:email], options[:'telephone number'])).and_return(OpenStruct.new(user: { 'username' => cognito_uuid }))
  allow(aws_client).to receive(:admin_set_user_mfa_preference).with(**enable_mfa_params(cognito_uuid))

  role_and_service_access_to_group_names([options[:role]], options[:'service access']&.split(',')).each do |group_name|
    allow(aws_client).to receive(:admin_add_user_to_group).with(**add_user_to_group_params(cognito_uuid, group_name))
  end
end
# rubocop:enable Metrics/AbcSize

def stub_find_users(aws_client, **options)
  if options[:search]
    allow(aws_client).to receive(:list_users).with(
      {
        user_pool_id: ENV['COGNITO_USER_POOL_ID'],
        attributes_to_get: ['email'],
        filter: "email ^= \"#{options[:search]}\""
      }
    ).and_return(
      OpenStruct.new(
        users: options[:users].map { |found_user| OpenStruct.new(username: SecureRandom.uuid, enabled: found_user[:account_status], attributes: [OpenStruct.new(name: 'email', value: found_user[:email])]) }
      )
    )
  else
    allow(aws_client).to receive(:list_users).and_raise(StandardError.new('Unexpected call to list users'))
  end
end

def stub_create_user_error(aws_client, error)
  allow(aws_client).to receive(:admin_create_user).and_raise(error)
end

def stub_find_users_error(aws_client, error)
  allow(aws_client).to receive(:list_users).and_raise(error)
end

def stub_find_user_error(aws_client, error)
  allow(aws_client).to receive(:admin_get_user).and_raise(error)
end

def role_and_service_access_to_group_names(roles, service_accesses)
  (roles || []).map { |role| ROLE_SERVICE_ACCESS_TO_GROUP_NAMES[role] } + (service_accesses || []).map { |service_access| ROLE_SERVICE_ACCESS_TO_GROUP_NAMES[service_access] }
end

def list_users_params(email)
  {
    user_pool_id: ENV['COGNITO_USER_POOL_ID'],
    attributes_to_get: ['email'],
    filter: "email = \"#{email}\""
  }
end

def create_user_params(email, telephone_number)
  user_attributes = {
    user_pool_id: ENV['COGNITO_USER_POOL_ID'],
    username: email,
    user_attributes: [
      {
        name: 'email',
        value: email
      },
      {
        name: 'email_verified',
        value: 'true'
      }
    ],
    desired_delivery_mediums: ['EMAIL']
  }

  if telephone_number
    user_attributes[:user_attributes] << {
      name: 'phone_number',
      value: telephone_number
    }
  end

  user_attributes
end

def enable_mfa_params(cognito_uuid)
  {
    sms_mfa_settings: {
      enabled: true,
      preferred_mfa: true,
    },
    user_pool_id: ENV['COGNITO_USER_POOL_ID'],
    username: cognito_uuid
  }
end

def add_user_to_group_params(cognito_uuid, group_name)
  {
    user_pool_id: ENV['COGNITO_USER_POOL_ID'],
    username: cognito_uuid,
    group_name: group_name
  }
end

ROLE_SERVICE_ACCESS_TO_GROUP_NAMES = {
  'Buyer' => 'buyer',
  'Service admin' => 'ccs_employee',
  'User support' => 'allow_list_access',
  'User admin' => 'ccs_user_admin',
  'Facilities Management' => 'fm_access',
  'Supply Teachers' => 'st_access',
  'Legal Services' => 'ls_access',
  'Management Consultancy' => 'mc_access'
}.freeze
