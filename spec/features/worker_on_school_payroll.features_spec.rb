require 'rails_helper'

RSpec.feature 'Workers on school payroll', type: :feature do
  scenario 'Buyer finds suppliers within search range' do
    Geocoder::Lookup::Test.add_stub(
      'WC2B 6TE', [{ 'coordinates' => [51.5149666, -0.119098] }]
    )

    holborn = Supplier.create!(name: 'holborn')
    holborn.branches.create!(
      postcode: 'WC2B 6TE',
      telephone_number: '020 7946 0001',
      contact_name: 'Bruce Waynne',
      contact_email: 'bruce.waynne@example.com',
      location: Geocoding.point(latitude: 51.5149666, longitude: -0.119098)
    )
    westminster = Supplier.create!(name: 'westminster')
    westminster.branches.create!(
      postcode: 'W1A 1AA',
      telephone_number: '020 7946 0002',
      contact_name: 'George Staunton',
      contact_email: 'george.staunton@example.com',
      location: Geocoding.point(latitude: 51.5185614, longitude: -0.1437991)
    )
    liverpool = Supplier.create!(name: 'liverpool')
    liverpool.branches.create!(
      postcode: 'L3 9PP',
      telephone_number: '020 7946 0003',
      contact_name: 'Emily Groves',
      contact_email: 'emily.groves@example.com',
      location: Geocoding.point(latitude: 53.409189, longitude: -2.9946932)
    )

    visit '/'
    click_on 'Start now'

    choose 'No'
    click_on 'Continue'

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
