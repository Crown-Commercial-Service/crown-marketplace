require 'rails_helper'

RSpec.describe 'supply_teachers/branches/_branch.html.erb' do
  let(:supplier) { build(:supplier) }
  let(:branch_name) { 'Head Office' }
  let(:branch_town) { 'Guildford' }
  let(:telephone_number) { Faker::PhoneNumber.unique.phone_number }
  let(:contact_name) { Faker::Name.unique.name }
  let(:contact_email) { Faker::Internet.unique.email }
  let(:branch) do
    SupplyTeachers::BranchSearchResult.new(
      supplier_name: supplier.name,
      name: branch_name,
      telephone_number: telephone_number,
      contact_name: contact_name,
      contact_email: contact_email
    )
  end

  before do
    render 'supply_teachers/branches/branch', branch: branch
  end

  it 'displays branch name' do
    expect(rendered).to have_content(branch_name)
  end

  it 'displays contact name' do
    expect(rendered).to have_content(contact_name)
  end

  it 'displays telephone number' do
    expect(rendered).to have_content(telephone_number)
  end

  it 'displays contact email' do
    expect(rendered).to have_content(contact_email)
  end

  context 'when branch name is blank' do
    let(:branch_name) { nil }

    it 'does not display branch or its label' do
      expect(rendered).not_to have_content('Branch:')
    end
  end
end
