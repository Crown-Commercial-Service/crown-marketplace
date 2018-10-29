require 'rails_helper'

RSpec.describe 'home/supply-teachers.html.erb' do
  it 'displays start button link' do
    render

    expect(rendered).to have_link(
      'Start now', href: journey_question_path(journey: 'teacher-supply', slug: 'looking-for')
    )
  end
end
