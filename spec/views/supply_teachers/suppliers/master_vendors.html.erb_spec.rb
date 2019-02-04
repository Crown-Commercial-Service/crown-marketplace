require 'rails_helper'

RSpec.describe 'supply_teachers/suppliers/master_vendors.html.erb' do
  let(:suppliers) { [] }

  before do
    assign(:suppliers, suppliers)
  end

  it 'displays the number of suppliers' do
    render
    expect(rendered).to have_text(/0 agencies/)
  end
end
