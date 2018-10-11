require 'rails_helper'

RSpec.describe Supplier, type: :model do
  subject(:supplier) { build(:supplier) }

  it { is_expected.to be_valid }

  it 'is not valid if name is blank' do
    supplier.name = ''
    expect(supplier).not_to be_valid
  end

  context 'when supplier with branches is destroyed' do
    before do
      supplier.save!
    end

    let!(:first_branch) { create(:branch, supplier: supplier) }
    let!(:second_branch) { create(:branch, supplier: supplier) }

    it 'destroys all its branches when it is destroyed' do
      supplier.destroy!

      expect(Branch.find_by(id: first_branch.id)).to be_nil
      expect(Branch.find_by(id: second_branch.id)).to be_nil
    end
  end
end
