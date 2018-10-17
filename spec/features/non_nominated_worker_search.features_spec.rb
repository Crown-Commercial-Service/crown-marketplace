require 'rails_helper'

RSpec.feature 'Non-nominated workers', type: :feature do
  scenario 'Buyer is not looking for a nominated worker' do
    visit '/'
    click_on 'Start now'

    choose 'Hire a worker via an agency'
    click_on 'Continue'

    choose 'No'
    click_on 'Continue'

    expect(page).to have_text('This system only allows you to search for nominated workers at the moment')
  end
end
