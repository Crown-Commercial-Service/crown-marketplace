require 'rails_helper'

RSpec.feature 'Nominated workers', type: :feature do
  scenario 'Buyer choice should not be pre-selected' do
    visit '/'
    click_on 'Start now'

    expect(page).not_to have_checked_field('Yes')
    expect(page).not_to have_checked_field('No')
  end

  scenario 'Buyer is not looking for a nominated worker' do
    visit '/'
    click_on 'Start now'

    choose 'No'
    click_on 'Continue'

    expect(page).to have_text('This system only allows you to search for nominated workers at the moment')
  end

  scenario 'Buyer was looking for a nominated worker but changed mind' do
    visit '/'
    click_on 'Start now'

    choose 'Yes'
    click_on 'Continue'

    click_on 'Back'

    expect(page).to have_checked_field('Yes')
  end

  scenario 'Buyer was not looking for a nominated worker but changed mind' do
    visit '/'
    click_on 'Start now'

    choose 'No'
    click_on 'Continue'

    click_on 'Back'

    expect(page).to have_checked_field('No')
  end

  scenario 'Buyer finds suppliers within search range' do
    Geocoder::Lookup::Test.add_stub(
      'WC2B 6TE', [{ 'coordinates' => [51.5149666, -0.119098] }]
    )

    holborn = create(:supplier, name: 'holborn')
    create(
      :rate,
      supplier: holborn,
      job_type: 'nominated',
      mark_up: 0.35
    )
    create(
      :branch,
      supplier: holborn,
      location: Geocoding.point(latitude: 51.5149666, longitude: -0.119098)
    )
    westminster = create(:supplier, name: 'westminster')
    create(
      :rate,
      supplier: westminster,
      job_type: 'nominated',
      mark_up: 0.30
    )
    create(
      :branch,
      supplier: westminster,
      location: Geocoding.point(latitude: 51.5185614, longitude: -0.1437991)
    )
    whitechapel = create(:supplier, name: 'whitechapel')
    create(
      :branch,
      supplier: whitechapel,
      location: Geocoding.point(latitude: 51.5106034, longitude: -0.0604652)
    )
    liverpool = create(:supplier, name: 'liverpool')
    create(
      :branch,
      supplier: liverpool,
      location: Geocoding.point(latitude: 53.409189, longitude: -2.9946932)
    )

    visit '/'
    click_on 'Start now'

    choose 'Yes'
    click_on 'Continue'

    fill_in 'postcode', with: 'WC2B 6TE'
    click_on 'Continue'

    expect(page).not_to have_text('whitechapel'), 'suppliers without nominated worker rates should not be displayed'

    branches = page.all('.branch')
    cheaper_branch = branches.first
    costlier_branch = branches.last

    expect(cheaper_branch.find('h2').text).to eq('westminster')
    expect(cheaper_branch).to have_css('.distance', text: '1.1')
    expect(cheaper_branch).to have_css('.markup_rate', text: '30.0%')

    expect(costlier_branch.find('h2').text).to eq('holborn')
    expect(costlier_branch).to have_css('.distance', text: '0.0')
    expect(costlier_branch).to have_css('.markup_rate', text: '35.0%')

    expect(page).not_to have_text('liverpool')
  end
end
