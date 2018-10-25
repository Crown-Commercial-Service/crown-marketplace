require 'rails_helper'

RSpec.describe 'search/worker_type.html.erb' do
  it 'stores answer to hire via agency question in hidden field' do
    @back_path = '/'
    @form_path = '/'
    params[:looking_for] = 'looking-for'
    render
    expect(rendered).to have_css('input[name="looking_for"][value="looking-for"]', visible: false)
  end
end
