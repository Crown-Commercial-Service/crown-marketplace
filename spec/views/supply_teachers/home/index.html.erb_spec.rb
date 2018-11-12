require 'rails_helper'

RSpec.describe 'supply_teachers/home/index.html.erb' do
  it 'displays start button link' do
    render

    expect(rendered).to have_link(
      'Start now', href: journey_start_url(journey: 'supply-teachers')
    )
  end
end
