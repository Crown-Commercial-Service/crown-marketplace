require 'rails_helper'

RSpec.describe 'branches/_branch.html.erb' do
  let(:supplier) { Supplier.new(name: 'Supplier') }
  let(:contact_name) { 'Henrietta Crouch' }
  let(:contact_email) { 'henrietta.crouch@example.com' }
  let(:branch) do
    supplier.branches.build(
      contact_name: contact_name,
      contact_email: contact_email
    )
  end

  before do
    render partial: branch
  end

  it 'displays contact name' do
    expect(rendered).to have_content(contact_name)
  end

  it 'displays contact email' do
    expect(rendered).to have_content(contact_email)
  end
end
