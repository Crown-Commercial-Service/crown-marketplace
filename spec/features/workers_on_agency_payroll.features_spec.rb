require 'rails_helper'

RSpec.feature 'Workers on agency payroll', type: :feature do
  scenario 'Buyer finds supplier within search range' do
    Geocoder::Lookup::Test.add_stub(
      'WC2B 6TE', [{ 'coordinates' => [51.5149666, -0.119098] }]
    )

    holborn = create(:supplier, name: 'holborn')
    create(
      :rate,
      supplier: holborn,
      job_type: 'qt_sen',
      term: 'twelve_weeks',
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
      job_type: 'qt_sen',
      term: 'twelve_weeks',
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
    create(
      :rate,
      supplier: whitechapel,
      job_type: 'senior',
      term: 'twelve_weeks',
      mark_up: 0.30
    )
    liverpool = create(:supplier, name: 'liverpool')
    create(
      :branch,
      supplier: liverpool,
      location: Geocoding.point(latitude: 53.409189, longitude: -2.9946932)
    )

    visit '/'
    click_on 'Start now'

    choose 'An individual worker'
    click_on 'Continue'

    choose 'No'
    click_on 'Continue'

    choose 'No'
    click_on 'Continue'

    fill_in 'postcode', with: 'WC2B 6TE'
    select '4 weeks to 8 weeks', from: 'term'
    select 'Qualified teacher: SEN roles', from: 'job_type'
    click_on 'Continue'

    expect(page).not_to have_text('whitechapel'), 'suppliers without appropriate rates should not be displayed'

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
end
