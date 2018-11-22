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

    visit 'supply-teachers'

    expect(page).to have_text('Find supply teachers')
  end

  scenario 'Users signed in using DfE sign-in can sign out' do
    visit '/'

    click_on 'Sign in with DfE Sign-in'
    click_on 'Sign out'

    visit '/supply-teachers'
    expect(page).to have_text('Sign in with beta credentials')
  end
end
