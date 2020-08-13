require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }
  let(:cognito_groups) do
    OpenStruct.new(groups: [
                     OpenStruct.new(group_name: 'buyer'),
                     OpenStruct.new(group_name: 'fm_access')
                   ])
  end

  before do
    allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
    allow(aws_client).to receive(:initiate_auth).and_return(OpenStruct.new(session: '1234667'))
    allow(aws_client).to receive(:admin_list_groups_for_user).and_return(cognito_groups)
    create_cookie('foo', 'bar')
  end

  scenario 'Unauthenticated users cannot access protected pages' do
    OmniAuth.config.test_mode = false
    visit '/facilities-management/gateway'

    expect(page).to have_text('Sign in with Cognito')
  end

  scenario 'Users can sign in using AWS Cognito' do
    OmniAuth.config.test_mode = false
    user = create(:user, :without_detail, roles: %i[buyer fm_access])
    visit '/facilities-management/gateway'
    click_on 'Sign in with Cognito'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'ValidPassword!'
    click_button 'Sign in'
    expect(page).not_to have_text('Not permitted')
    expect(page).to have_text('Find a facilities management supplier')
  end

  scenario 'Users can sign in using AWS Cognito with capitals in email' do
    user = create(:user, :without_detail, roles: %i[buyer fm_access])
    visit '/facilities-management/gateway'
    click_on 'Sign in with Cognito'
    fill_in 'Email', with: user.email.upcase
    fill_in 'Password', with: 'ValidPassword!'
    click_button 'Sign in'
    expect(page).not_to have_text('Not permitted')
    expect(page).to have_text('Find a facilities management supplier')
  end

  scenario 'Users signed in using AWS Cognito can sign out' do
    user = create(:user, :without_detail, roles: %i[buyer fm_access])
    visit '/facilities-management/gateway'
    click_on 'Sign in with Cognito'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'ValidPassword!'
    click_button 'Sign in'
    click_on 'Sign out'

    visit '/facilities-management/gateway'
    expect(page).to have_text('Sign in with Cognito')
  end
end
