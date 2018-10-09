require 'rails_helper'

RSpec.feature 'PostcodeSearch.features', type: :feature do
  scenario 'User finds suppliers within search range' do
    Geocoder::Lookup::Test.add_stub(
      'WC2B 6TE', [{ 'coordinates' => [51.5149666, -0.119098] }]
    )

    point_factory = RGeo::Geographic.spherical_factory(srid: 4326)

    holborn = Supplier.create!(name: 'holborn')
    holborn.branches.create!(
      postcode: 'WC2B 6TE',
      contact_name: 'Bruce Waynne',
      contact_email: 'bruce.waynne@example.com',
      location: point_factory.point(-0.119098, 51.5149666)
    )
    westminster = Supplier.create!(name: 'westminster')
    westminster.branches.create!(
      postcode: 'W1A 1AA',
      contact_name: 'George Staunton',
      contact_email: 'george.staunton@example.com',
      location: point_factory.point(-0.1437991, 51.5185614)
    )
    liverpool = Supplier.create!(name: 'liverpool')
    liverpool.branches.create!(
      postcode: 'L3 9PP',
      contact_name: 'Emily Groves',
      contact_email: 'emily.groves@example.com',
      location: point_factory.point(-2.9946932, 53.409189)
    )

    visit '/search'

    fill_in 'postcode', with: 'WC2B 6TE'
    click_button 'Continue'

    holborn_branch = page.find('h2', text: 'holborn').ancestor('.branch')
    expect(holborn_branch).to have_css('.distance', text: '0.0')
    westminster_branch = page.find('h2', text: 'westminster').ancestor('.branch')
    expect(westminster_branch).to have_css('.distance', text: '1.1')
    expect(page).not_to have_text('liverpool')
  end

  scenario 'Postcode is not recognised' do
    Geocoder::Lookup::Test.add_stub(
      'SE99 1AA', [{ 'coordinates' => nil }]
    )

    visit '/search'

    fill_in 'postcode', with: 'SE99 1AA'
    click_button 'Continue'

    expect(page).to have_text("Couldn't find that postcode")
  end
end
