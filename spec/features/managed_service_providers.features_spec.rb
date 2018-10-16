require 'rails_helper'

RSpec.feature 'Managed service providers', type: :feature do
  scenario 'Hire via agency choice should not be pre-selected' do
    visit '/'
    click_on 'Start now'

    expect(page).not_to have_checked_field('Yes')
    expect(page).not_to have_checked_field('No')
  end

  scenario 'Buyer wants to hire a managed service provider' do
    visit '/'
    click_on 'Start now'

    choose 'Hire a managed service provider'
    click_on 'Continue'

    expect(page).to have_text('Managed service providers')
  end

  scenario 'Buyer changes mind about hiring a managed service provider' do
    visit '/'
    click_on 'Start now'

    choose 'Hire a managed service provider'
    click_on 'Continue'

    click_on 'Back'

    expect(page).not_to have_checked_field('No')
  end
end
