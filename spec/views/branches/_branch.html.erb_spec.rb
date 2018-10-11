require 'rails_helper'

RSpec.describe 'branches/_branch.html.erb' do
  let(:accreditation_body) { 'REC' }
  let(:supplier) do
    build(
      :supplier,
      name: 'Supplier',
      accreditation_body: accreditation_body
    )
  end
  let(:branch_name) { 'Head Office' }
  let(:branch_town) { 'Guildford' }
  let(:telephone_number) { Faker::PhoneNumber.unique.phone_number }
  let(:contact_name) { Faker::Name.unique.name }
  let(:contact_email) { Faker::Internet.unique.email }
  let(:branch) do
    build(
      :branch,
      supplier: supplier,
      name: branch_name,
      town: branch_town,
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

    it 'displays town as branch name' do
      expect(rendered).to have_content("Branch: #{branch_town}")
    end
  end

  context 'when branch name and town are blank' do
    let(:branch_name) { nil }
    let(:branch_town) { nil }

    it 'does not display branch or its label' do
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
