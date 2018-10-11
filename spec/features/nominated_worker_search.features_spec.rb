require 'rails_helper'

RSpec.feature 'Nominated workers', type: :feature do
  scenario 'Buyer is not looking for a nominated worker' do
    visit '/'
    click_on 'Start now'

    choose 'No'
    click_on 'Continue'

    expect(page).to have_text('This system only allows you to search for nominated workers at the moment')
  end

  scenario 'Buyer finds suppliers within search range' do
    Geocoder::Lookup::Test.add_stub(
      'WC2B 6TE', [{ 'coordinates' => [51.5149666, -0.119098] }]
    )

    holborn = create(:supplier, name: 'holborn')
    create(
      :branch,
      supplier: holborn,
      location: Geocoding.point(latitude: 51.5149666, longitude: -0.119098)
    )
    westminster = create(:supplier, name: 'westminster')
    create(
      :branch,
      supplier: westminster,
      location: Geocoding.point(latitude: 51.5185614, longitude: -0.1437991)
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

    holborn_branch = page.find('h2', text: 'holborn').ancestor('.branch')
    expect(holborn_branch).to have_css('.distance', text: '0.0')
    westminster_branch = page.find('h2', text: 'westminster').ancestor('.branch')
    expect(westminster_branch).to have_css('.distance', text: '1.1')
    expect(page).not_to have_text('liverpool')
  end
end
