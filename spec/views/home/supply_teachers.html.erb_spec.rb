require 'rails_helper'

RSpec.describe 'home/supply-teachers.html.erb' do
  it 'displays start button link' do
    render

    expect(rendered).to have_link(
      'Start now', href: journey_start_url(journey: 'teacher-supply')
    )
  end
end
