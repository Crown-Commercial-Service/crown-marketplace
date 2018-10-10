require 'rails_helper'

RSpec.describe Supplier, type: :model do
  subject(:supplier) { described_class.new(name: 'supplier-name') }

  it { is_expected.to be_valid }

  it 'is not valid if name is blank' do
    supplier.name = ''
    expect(supplier).not_to be_valid
  end

  context 'when supplier with branches is destroyed' do
    before do
      supplier.save!
    end

    let!(:first_branch) do
      supplier.branches.create!(
        postcode: 'SW1A 1AA',
        contact_name: 'George Henry',
        contact_email: 'george.henry@example.com'
      )
    end

    let!(:second_branch) do
      supplier.branches.create!(
        postcode: 'E1 6EA',
        contact_name: 'Fred Rogers',
        contact_email: 'fred.rogers@example.com'
      )
    end

    it 'destroys all its branches when it is destroyed' do
      supplier.destroy!

      expect(Branch.find_by(id: first_branch.id)).to be_nil
      expect(Branch.find_by(id: second_branch.id)).to be_nil
    end
  end
end
