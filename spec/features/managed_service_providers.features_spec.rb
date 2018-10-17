require 'rails_helper'

RSpec.feature 'Managed service providers', type: :feature do
  scenario 'Hire via agency choice should not be pre-selected' do
    visit '/'
    click_on 'Start now'

    expect(page).not_to have_checked_field('Yes')
    expect(page).not_to have_checked_field('No')
  end

  scenario 'Buyer wants to hire a master vendor managed service' do
    visit '/'
    click_on 'Start now'

    choose 'Hire a managed service provider'
    click_on 'Continue'

    choose 'Master vendor'
    click_on 'Continue'

    expect(page).to have_text('Master vendor managed service')
  end

  scenario 'Buyer wants to hire a neutral vendor managed service' do
    visit '/'
    click_on 'Start now'

    choose 'Hire a managed service provider'
    click_on 'Continue'

    choose 'Neutral vendor'
    click_on 'Continue'

    expect(page).to have_text('Neutral vendor managed service')
  end

  scenario 'Buyer changes mind about hiring a managed service provider' do
    visit '/'
    click_on 'Start now'

    choose 'Hire a managed service provider'
    click_on 'Continue'

    choose 'Master vendor'
    click_on 'Continue'

    click_on 'Back'
    click_on 'Back'

    expect(page).to have_checked_field('Hire a managed service provider')
  end

  scenario 'Buyer changes mind about hiring a master vendor managed service' do
    visit '/'
    click_on 'Start now'

    choose 'Hire a managed service provider'
    click_on 'Continue'

    choose 'Master vendor'
    click_on 'Continue'

    click_on 'Back'

    expect(page).to have_checked_field('Master vendor')
  end

  scenario 'Buyer changes mind about hiring a neutral vendor managed service' do
    visit '/'
    click_on 'Start now'

    choose 'Hire a managed service provider'
    click_on 'Continue'

    choose 'Neutral vendor'
    click_on 'Continue'

    click_on 'Back'

    expect(page).to have_checked_field('Neutral vendor')
  end
end
