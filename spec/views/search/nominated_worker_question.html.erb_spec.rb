require 'rails_helper'

RSpec.describe 'search/nominated_worker_question.html.erb' do
  it 'stores answer to hire via agency question in hidden field' do
    params[:hire_via_agency] = 'hire-via-agency'
    render
    expect(rendered).to have_css('input[name="hire_via_agency"][value="hire-via-agency"]', visible: false)
  end
end
