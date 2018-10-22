require 'rails_helper'

RSpec.describe 'home/index.html.erb' do
  it 'displays start button link' do
    render

    expect(rendered).to have_link(
      'Start now', href: search_question_path(slug: 'hire-via-agency')
    )
  end
end
