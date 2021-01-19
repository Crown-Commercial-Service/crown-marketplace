def cognito_groups
  OpenStruct.new(groups: [
      OpenStruct.new(group_name: 'fm_access'),
      OpenStruct.new(group_name: 'ccs_employee')
  ])
end

def cognito_user
  username =  '123456'
  email = 'user@email.com'
  name = 'Scooby'
  family_name = 'Doo'
  phone_number ='+447500594946'
  OpenStruct.new(
      user_attributes: [
          OpenStruct.new(name: 'sub', value: username),
          OpenStruct.new(name: 'email', value: email),
          OpenStruct.new(name: 'name', value: name),
          OpenStruct.new(name: 'family_name', value: family_name),
          OpenStruct.new(name: 'phone_number', value: phone_number)
      ]
  )
end


def login_user

  aws_client = instance_double(Aws::CognitoIdentityProvider::Client)
  allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
  allow(aws_client).to receive(:admin_get_user).and_return(cognito_user)
  allow(aws_client).to receive(:initiate_auth).and_return(OpenStruct.new(session: '1234667'))
  allow(aws_client).to receive(:admin_list_groups_for_user).and_return(cognito_groups)

  # create_cookie('foo', 'bar')

  OmniAuth.config.test_mode = false
  user = create(:user, :without_detail, roles: %i[ccs_employee fm_access])
  visit 'facilities-management/start'
  click_on 'Start now'
  click_on 'Sign in with Cognito'
  fill_in 'Email', with: user.email
  fill_in 'Password', with: 'ValidPassword!'
  click_button 'Sign in'

end