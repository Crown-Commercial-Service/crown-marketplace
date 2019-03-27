require 'rails_helper'

RSpec.describe 'supply_teachers/suppliers/all_suppliers.html.erb' do
  let(:supplier) { create(:supply_teachers_supplier) }
  let(:branch) { create(:supply_teachers_branch, supplier: supplier) }

  before do
    assign(:branches, SupplyTeachers::Branch.all.page)
    assign(:branches_count, 10)
  end

  it 'displays all agencies page' do
    render
    expect(rendered).to have_text(/All agencies/)
    expect(rendered).to have_text(/There are 10 agencies currently available/)
  end
end
