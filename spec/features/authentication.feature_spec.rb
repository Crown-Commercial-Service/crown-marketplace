require 'rails_helper'

RSpec.feature 'Authentication' do
  include_context 'with cognito structs'

  let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }
  let(:cognito_groups) do
    admin_list_groups_for_user_resp_struct.new(
      groups: [
        cognito_group_struct.new(group_name: 'buyer'),
        cognito_group_struct.new(group_name: 'fm_access')
      ]
    )
  end

  before do
    allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
    allow(aws_client).to receive(:initiate_auth).and_return(initiate_auth_resp_struct.new(session: '1234667'))
    allow(aws_client).to receive(:admin_list_groups_for_user).and_return(cognito_groups)
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(Cognito::SignInUser).to receive(:sleep)
    # rubocop:enable RSpec/AnyInstance
    create_cookie('foo', 'bar')
  end

  scenario 'Unauthenticated users cannot access protected pages' do
    OmniAuth.config.test_mode = false
    visit '/facilities-management/RM3830/sign-in'

    expect(page).to have_text('Sign in to your account')
  end

  scenario 'Users can sign in using AWS Cognito' do
    OmniAuth.config.test_mode = false
    user = create(:user, :without_detail, roles: %i[buyer fm_access])
    visit '/facilities-management/RM3830/sign-in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'ValidPassword!'
    click_button 'Sign in'
    expect(page).not_to have_text('Not permitted')
    expect(page).to have_text('Find a facilities management supplier')
  end

  scenario 'Users can sign in using AWS Cognito with capitals in email' do
    user = create(:user, :without_detail, roles: %i[buyer fm_access])
    visit '/facilities-management/RM3830/sign-in'
    fill_in 'Email', with: user.email.upcase
    fill_in 'Password', with: 'ValidPassword!'
    click_button 'Sign in'
    expect(page).not_to have_text('Not permitted')
    expect(page).to have_text('Find a facilities management supplier')
  end

  scenario 'Users signed in using AWS Cognito can sign out' do
    user = create(:user, :with_detail, roles: %i[buyer fm_access])
    visit '/facilities-management/RM3830/sign-in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'ValidPassword!'
    click_button 'Sign in'
    click_on 'Sign out'

    visit '/facilities-management/RM3830/sign-in'
    expect(page).to have_text('Sign in to your account')
  end
end
