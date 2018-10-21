require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  scenario 'Unauthenticated users cannot access protected pages' do
    visit '/supply-teachers'

    expect(page).to have_text('Log in with beta credentials')
  end

  scenario 'Users can sign in and access protected pages' do
    visit '/'

    click_on 'Log in with beta credentials'

    visit '/supply-teachers'

    expect(page).to have_text('Find supply teachers')
  end
end
