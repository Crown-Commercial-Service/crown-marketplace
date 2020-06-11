require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }
  let(:cognito_groups) do
    OpenStruct.new(groups: [
                     OpenStruct.new(group_name: 'buyer'),
                     OpenStruct.new(group_name: 'st_access'),
                     OpenStruct.new(group_name: 'mc_access')
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
    visit '/management-consultancy/start'

    expect(page).to have_text('Sign in with Cognito')
  end

  scenario 'Users can sign in using AWS Cognito' do
    OmniAuth.config.test_mode = false
    user = create(:user, :without_detail, roles: %i[buyer mc_access])
    visit '/management-consultancy/start'
    click_on 'Sign in with Cognito'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'ValidPassword!'
    click_button 'Sign in'
    expect(page).not_to have_text('Not permitted')
    expect(page).to have_text('Confirm you need management consultancy')
  end

  scenario 'Users can sign in using AWS Cognito with capitals in email' do
    user = create(:user, :without_detail, roles: %i[buyer mc_access])
    visit '/management-consultancy/start'
    click_on 'Sign in with Cognito'
    fill_in 'Email', with: user.email.upcase
    fill_in 'Password', with: 'ValidPassword!'
    click_button 'Sign in'
    expect(page).not_to have_text('Not permitted')
    expect(page).to have_text('Confirm you need management consultancy')
  end

  scenario 'Users signed in using AWS Cognito can sign out' do
    user = create(:user, :without_detail, roles: %i[buyer mc_access])
    visit '/management-consultancy/start'
    click_on 'Sign in with Cognito'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'ValidPassword!'
    click_button 'Sign in'
    click_on 'Sign out'

    visit '/management-consultancy/start'
    expect(page).to have_text('Sign in with Cognito')
  end

  scenario 'Users can sign in using DfE sign-in', dfe: true do
    visit '/supply-teachers/start'
    click_on 'Sign in with DfE Sign-in'

    expect(page).not_to have_text('Not permitted')
    expect(page).to have_text('Find supply teachers')
  end

  scenario 'Users signed in using DfE sign-in can sign out', dfe: true do
    visit '/supply-teachers/start'
    click_on 'Sign in with DfE Sign-in'
    click_on 'Sign out'

    visit '/supply-teachers/start'

    expect(page).to have_xpath("//input[@value='Sign in with DfE Sign-in']")
  end

  scenario 'DfE users cannot see other frameworks', dfe: true do
    visit '/supply-teachers/start'
    click_on 'Sign in with DfE Sign-in'

    visit '/management-consultancy/start'

    expect(page).to have_text(I18n.t('shared.not_permitted.management_consultancy.title'))
  end

  scenario 'DfE users cannot see school pages if they are from a for-profit school' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:dfe] = OmniAuth::AuthHash.new(
      'provider' => 'dfe',
      'info' => { 'email' => 'dfe@example.com' },
      'extra' => {
        'raw_info' => {
          'organisation' => {
            'id' => '047F32E7-FDD5-46E9-89D4-2498C2E77364',
            'name' => 'St Custard’s',
            'urn' => '900002',
            'ukprn' => '90000002',
            'category' => {
              'id' => '001',
              'name' => 'Establishment'
            },
            'type' => {
              'id' => '11',
              'name' => 'Other independent school'
            }
          }
        }
      }
    )

    visit '/supply-teachers/start'

    click_on 'Sign in with DfE Sign-in'

    expect(page).to have_text(I18n.t('shared.not_permitted.supply_teachers.title'))
    OmniAuth.config.mock_auth[:dfe] = nil
  end

  scenario 'DfE users cannot see school pages if they are not on the whitelist', dfe: true do
    allow(Marketplace)
      .to receive(:dfe_signin_whitelist_enabled?)
      .and_return(true)
    allow(Marketplace)
      .to receive(:dfe_signin_whitelisted_email_addresses)
      .and_return([])
    visit '/supply-teachers/start'
    click_on 'Sign in with DfE Sign-in'

    expect(page).to have_text(I18n.t('shared.not_permitted.supply_teachers.title'))
  end

  context 'when user if fm admin' do
    let(:cognito_groups) do
      OpenStruct.new(groups: [
                       OpenStruct.new(group_name: 'fm_access'),
                       OpenStruct.new(group_name: 'ccs_employee')
                     ])
    end

    scenario 'can sign into the admin tool using AWS Cognito' do
      OmniAuth.config.test_mode = false
      user = create(:user, :without_detail, roles: %i[ccs_employee fm_access])
      visit '/facilities-management/admin/gateway'
      click_on 'Sign in with Cognito'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'ValidPassword!'
      click_button 'Sign in'
      expect(page).not_to have_text('Not permitted')
      expect(page).to have_text('RM3830 administration dashboard')
    end
  end

  context 'when user if mc admin' do
    let(:cognito_groups) do
      OpenStruct.new(groups: [
                       OpenStruct.new(group_name: 'mc_access'),
                       OpenStruct.new(group_name: 'ccs_employee')
                     ])
    end

    scenario 'cannot sign into the admin tool using AWS Cognito' do
      OmniAuth.config.test_mode = false
      user = create(:user, :without_detail, roles: %i[ccs_employee mc_access])
      visit '/facilities-management/admin/gateway'
      click_on 'Sign in with Cognito'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'ValidPassword!'
      click_button 'Sign in'
      expect(page).to have_text('Sorry, you are not authorised to view this page')
      expect(page).not_to have_text('RM3830 administration dashboard')
    end
  end
end
