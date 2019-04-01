require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  scenario 'Unauthenticated users cannot access protected pages' do
    visit '/management-consultancy/start'

    expect(page).to have_text('Sign in with beta credentials')
  end

  scenario 'Users can sign in using AWS Cognito' do
    visit '/management-consultancy/start'
    click_on 'Sign in with beta credentials'

    expect(page).not_to have_text('Not permitted')
    expect(page).to have_text('What do you need to procure?')
  end

  scenario 'Users signed in using AWS Cognito can sign out' do
    allow(Cognito).to receive(:logout_url).and_return('/management-consultancy')

    visit '/management-consultancy/start'
    click_on 'Sign in with beta credentials'
    click_on 'Sign out'

    visit '/management-consultancy/start'

    expect(page).to have_text('Sign in with beta credentials')
  end

  scenario 'Redirection to requested page after auth' do
    path = '/supply-teachers/worker-type?looking_for=worker'
    visit path
    click_on 'Sign in with DfE Sign-in'
    expect(page).to have_current_path(path)
  end

  scenario 'Users can sign in using DfE sign-in' do
    visit '/supply-teachers/start'
    click_on 'Sign in with DfE Sign-in'

    expect(page).not_to have_text('Not permitted')
    expect(page).to have_text('Find supply teachers')
  end

  scenario 'Users signed in using DfE sign-in can sign out' do
    visit '/supply-teachers/start'
    click_on 'Sign in with DfE Sign-in'
    click_on 'Sign out'

    visit '/supply-teachers/start'

    expect(page).to have_text('Sign in with DfE Sign-in')
  end

  scenario 'DfE users cannot see other frameworks' do
    visit '/supply-teachers/start'
    click_on 'Sign in with DfE Sign-in'

    visit '/management-consultancy/start'

    expect(page).to have_text(I18n.t('shared.not_permitted.management_consultancy.title'))
  end

  scenario 'DfE users cannot see school pages if they are from a for-profit school' do
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

    visit '/supply-teachers/start'

    expect(page).to have_text(I18n.t('shared.not_permitted.supply_teachers.title'))
  end

  scenario 'DfE users cannot see school pages if they are not on the whitelist' do
    allow(Marketplace)
      .to receive(:dfe_signin_whitelist_enabled?)
      .and_return(true)
    allow(Marketplace)
      .to receive(:dfe_signin_whitelisted_email_addresses)
      .and_return([])
    visit '/supply-teachers/start'
    click_on 'Sign in with DfE Sign-in'

    visit '/supply-teachers/start'

    expect(page).to have_text(I18n.t('shared.not_permitted.supply_teachers.title'))
  end

  scenario 'Visitors to the normal school gateway do not see a Cognito option when disabled' do
    allow(Marketplace)
      .to receive(:supply_teachers_cognito_enabled?)
      .and_return(false)

    visit '/supply-teachers/start'

    expect(page).not_to have_text('Sign in with beta credentials')
  end

  scenario 'Visitors to the normal school gateway see a Cognito option when enabled' do
    allow(Marketplace)
      .to receive(:supply_teachers_cognito_enabled?)
      .and_return(true)

    visit '/supply-teachers/start'

    expect(page).to have_text('Sign in with beta credentials')
  end

  scenario 'Visitors to the internal school gateway see a Cognito option' do
    visit '/supply-teachers/cognito'

    expect(page).to have_text('Sign in with beta credentials')

    click_on 'Sign in with beta credentials'

    expect(page).to have_current_path('/supply-teachers')
  end
end
