require 'rails_helper'

RSpec.feature 'Nominated workers', type: :feature do
  scenario 'Buyer finds suppliers within search range' do
    Geocoder::Lookup::Test.add_stub(
      'WC2B 6TE', [{ 'coordinates' => [51.5149666, -0.119098] }]
    )

    holborn = create(:supplier, name: 'holborn')
    create(
      :rate,
      supplier: holborn,
      lot_number: 1,
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
      lot_number: 1,
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

    visit_home
    click_on 'Start now'

    choose 'An individual worker'
    click_on 'Continue'

    choose "No, I have a worker I want the agency to manage (a 'nominated worker')"
    click_on 'Continue'

    fill_in 'postcode', with: 'WC2B 6TE'
    click_on 'Continue'

    expect(page).not_to have_text('whitechapel'), 'suppliers without nominated worker rates should not be displayed'

    branches = page.all('.supplier-record')
    cheaper_branch = branches.first
    costlier_branch = branches.last

    expect(cheaper_branch.find('h2').text).to eq('westminster')
    expect(cheaper_branch).to have_css('.supplier-record__distance', text: '1.1')
    expect(cheaper_branch).to have_css('.supplier-record__markup-rate', text: '30.0%')

    expect(costlier_branch.find('h2').text).to eq('holborn')
    expect(costlier_branch).to have_css('.supplier-record__distance', text: '0.0')
    expect(costlier_branch).to have_css('.supplier-record__markup-rate', text: '35.0%')

    expect(page).not_to have_text('liverpool')
  end

  scenario 'Buyer changes mind about postcode' do
    Geocoder::Lookup::Test.add_stub(
      'WC2B 6TE', [{ 'coordinates' => [51.5149666, -0.119098] }]
    )

    visit_home
    click_on 'Start now'

    choose 'An individual worker'
    click_on 'Continue'

    choose "No, I have a worker I want the agency to manage (a 'nominated worker')"
    click_on 'Continue'

    fill_in 'postcode', with: 'WC2B 6TE'
    click_on 'Continue'

    click_on 'Back'

    expect(page).to have_field('postcode', with: 'WC2B 6TE')
  end

  scenario 'Buyer changes mind about postcode and nominated worker' do
    Geocoder::Lookup::Test.add_stub(
      'WC2B 6TE', [{ 'coordinates' => [51.5149666, -0.119098] }]
    )

    visit_home
    click_on 'Start now'

    choose 'An individual worker'
    click_on 'Continue'

    choose "No, I have a worker I want the agency to manage (a 'nominated worker')"
    click_on 'Continue'

    fill_in 'postcode', with: 'WC2B 6TE'
    click_on 'Continue'

    click_on 'Back'
    click_on 'Back'

    expect(page).to have_checked_field("No, I have a worker I want the agency to manage (a 'nominated worker')")
  end

  scenario 'Buyer changes mind about postcode, nominated worker & hire via agency' do
    Geocoder::Lookup::Test.add_stub(
      'WC2B 6TE', [{ 'coordinates' => [51.5149666, -0.119098] }]
    )

    visit_home
    click_on 'Start now'

    choose 'An individual worker'
    click_on 'Continue'

    choose "No, I have a worker I want the agency to manage (a 'nominated worker')"
    click_on 'Continue'

    fill_in 'postcode', with: 'WC2B 6TE'
    click_on 'Continue'

    click_on 'Back'
    click_on 'Back'
    click_on 'Back'

    expect(page).to have_checked_field('An individual worker')
  end

  scenario 'Buyer enters invalid postcode' do
    visit_home
    click_on 'Start now'

    choose 'An individual worker'
    click_on 'Continue'

    choose "No, I have a worker I want the agency to manage (a 'nominated worker')"
    click_on 'Continue'

    fill_in 'postcode', with: 'XY1 2AB'
    click_on 'Continue'

    expect(page).to have_text('Couldn’t find that postcode')
    expect(page).to have_field('postcode', with: 'XY1 2AB')
  end
end
