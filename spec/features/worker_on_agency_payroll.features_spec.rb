require 'rails_helper'

RSpec.feature 'Workers on agency payroll', type: :feature do
  scenario 'Buyer is looking for a worker on agency payroll' do
    visit '/'
    click_on 'Start now'

    choose 'No'
    click_on 'Continue'

    choose 'No'
    click_on 'Continue'

    expect(page).to have_text('This system only allows you to search for nominated workers and workers on school payroll at the moment')
  end
end
