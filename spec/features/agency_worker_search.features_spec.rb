require 'rails_helper'

RSpec.feature 'Agency workers', type: :feature do
  before do
    stub_auth
  end

  after do
    unstub_auth
  end

  scenario 'Nominated worker choice should not be pre-selected' do
    visit '/'
    click_on 'Log in with beta credentials'
    click_on 'Start now'

    choose 'Through an agency'
    click_on 'Continue'

    expect(page).not_to have_checked_field('Yes')
    expect(page).not_to have_checked_field('No')
  end

  scenario 'Buyer was looking for a nominated worker but changed mind' do
    visit '/'
    click_on 'Log in with beta credentials'
    click_on 'Start now'

    choose 'Through an agency'
    click_on 'Continue'

    choose 'Yes'
    click_on 'Continue'

    click_on 'Back'

    expect(page).to have_checked_field('Yes')
  end

  scenario 'Buyer was not looking for a nominated worker but changed mind' do
    visit '/'
    click_on 'Log in with beta credentials'
    click_on 'Start now'

    choose 'Through an agency'
    click_on 'Continue'

    choose 'No'
    click_on 'Continue'

    click_on 'Back'

    expect(page).to have_checked_field('No')
  end
end
