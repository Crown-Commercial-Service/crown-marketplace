require 'rails_helper'

RSpec.describe 'supply_teachers/branches/show.html.erb' do
  let(:supplier) { create(:supply_teachers_supplier) }
  let(:branch) { create(:supply_teachers_branch, supplier: supplier) }

  before do
    assign(:branch, branch)
  end

  it 'displays supplier and branch name' do
    render
    expect(rendered).to have_text(supplier.name)
    expect(rendered).to have_text(branch.name)
  end
end
