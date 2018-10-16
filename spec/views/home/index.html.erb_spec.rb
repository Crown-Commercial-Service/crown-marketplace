require 'rails_helper'

RSpec.describe 'home/index.html.erb' do
  it 'displays start button link' do
    render

    expect(rendered).to have_link(
      'Start now', href: hire_via_agency_question_path
    )
  end
end
