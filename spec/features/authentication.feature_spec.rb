require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  scenario 'Unauthenticated users cannot access protected pages' do
    visit '/supply-teachers'

    expect(page).to have_text('Sign in with beta credentials')
  end

  scenario 'Users can sign in using AWS Cognito' do
    visit '/'

    click_on 'Sign in with beta credentials'

    visit '/supply-teachers'

    expect(page).to have_text('Find supply teachers')
  end

  scenario 'Users signed in using AWS Cognito can sign out' do
    allow(Cognito).to receive(:logout_path).and_return('/')

    visit '/'

    click_on 'Sign in with beta credentials'

    click_on 'Sign out'

    visit '/supply-teachers'
    expect(page).to have_text('Sign in with beta credentials')
  end

  scenario 'Users can sign in using DfE sign-in' do
    visit '/'

    click_on 'Sign in with DfE Sign-in'

    expect(page).not_to have_text('Not permitted')

    visit '/supply-teachers'

    expect(page).to have_text('Find supply teachers')
  end

  scenario 'Users signed in using DfE sign-in can sign out' do
    visit '/'

    click_on 'Sign in with DfE Sign-in'
    click_on 'Sign out'

    visit '/supply-teachers'
    expect(page).to have_text('Sign in with beta credentials')
  end

  scenario 'DfE users cannot see other frameworks' do
    visit '/'

    click_on 'Sign in with DfE Sign-in'

    visit '/management-consultancy'

    expect(page).to have_text('You don’t have permission to view this page')
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

    visit '/'

    click_on 'Sign in with DfE Sign-in'

    visit 'supply-teachers'

    expect(page).to have_text('You don’t have permission to view this page')
  end
end
