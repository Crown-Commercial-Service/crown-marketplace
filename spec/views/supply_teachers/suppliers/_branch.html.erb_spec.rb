require 'rails_helper'

RSpec.describe 'supply_teachers/suppliers/_branch.html.erb' do
  let(:supplier) { create(:supply_teachers_supplier) }
  let(:branch) { create(:supply_teachers_branch, supplier: supplier) }

  before do
    render 'supply_teachers/suppliers/branch', branch: branch
  end

  it 'displays supplier and branch name' do
    expect(rendered).to have_text(supplier.name)
    expect(rendered).to have_text(branch.name)
  end
end
