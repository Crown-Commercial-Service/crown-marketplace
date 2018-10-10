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

    point_factory = RGeo::Geographic.spherical_factory(srid: 4326)

    holborn = Supplier.create!(name: 'holborn')
    holborn.branches.create!(
      postcode: 'WC2B 6TE',
      telephone_number: '020 7946 0001',
      contact_name: 'Bruce Waynne',
      contact_email: 'bruce.waynne@example.com',
      location: point_factory.point(-0.119098, 51.5149666)
    )
    westminster = Supplier.create!(name: 'westminster')
    westminster.branches.create!(
      postcode: 'W1A 1AA',
      telephone_number: '020 7946 0002',
      contact_name: 'George Staunton',
      contact_email: 'george.staunton@example.com',
      location: point_factory.point(-0.1437991, 51.5185614)
    )
    liverpool = Supplier.create!(name: 'liverpool')
    liverpool.branches.create!(
      postcode: 'L3 9PP',
      telephone_number: '020 7946 0003',
      contact_name: 'Emily Groves',
      contact_email: 'emily.groves@example.com',
      location: point_factory.point(-2.9946932, 53.409189)
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
