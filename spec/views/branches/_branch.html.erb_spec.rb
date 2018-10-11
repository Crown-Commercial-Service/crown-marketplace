require 'rails_helper'

RSpec.describe 'branches/_branch.html.erb' do
  let(:accreditation_body) { 'REC' }
  let(:supplier) do
    Supplier.new(
      name: 'Supplier',
      accreditation_body: accreditation_body
    )
  end
  let(:branch_name) { 'Head Office' }
  let(:telephone_number) { '020 7946 0001' }
  let(:contact_name) { 'Henrietta Crouch' }
  let(:contact_email) { 'henrietta.crouch@example.com' }
  let(:branch) do
    supplier.branches.build(
      name: branch_name,
      telephone_number: telephone_number,
      contact_name: contact_name,
      contact_email: contact_email
    )
  end

  before do
    render partial: branch
  end

  it 'displays branch name' do
    expect(rendered).to have_content(branch_name)
  end

  it 'displays accreditation body' do
    expect(rendered).to have_content(accreditation_body)
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

    it 'does not display branch name or its label' do
      expect(rendered).not_to have_content('Branch:')
    end
  end

  context 'when accreditation body is blank' do
    let(:accreditation_body) { nil }

    it 'does not display accreditation body or its label' do
      expect(rendered).not_to have_content('Accreditation Body:')
    end
  end
end
