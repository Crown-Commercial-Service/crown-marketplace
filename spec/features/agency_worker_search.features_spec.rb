require 'rails_helper'

RSpec.feature 'Agency workers', type: :feature do
  scenario 'Answers should not be pre-selected' do
    visit '/'
    click_on 'Start now'

    choose 'An individual worker'
    click_on 'Continue'

    expect(page).not_to have_checked_field('Yes')
    expect(page).not_to have_checked_field('No')
  end

  scenario 'Buyer was looking for a nominated worker but changed mind' do
    visit '/'
    click_on 'Start now'

    choose 'An individual worker'
    click_on 'Continue'

    choose 'Yes'
    click_on 'Continue'

    click_on 'Back'

    expect(page).to have_checked_field('Yes')
  end

  scenario 'Buyer was looking for an agency supplied worker but changed mind' do
    visit '/'
    click_on 'Start now'

    choose 'An individual worker'
    click_on 'Continue'

    choose 'No'
    click_on 'Continue'

    click_on 'Back'

    expect(page).to have_checked_field('No')
  end
end
