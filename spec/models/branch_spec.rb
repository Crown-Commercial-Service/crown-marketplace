require 'rails_helper'

RSpec.describe Branch, type: :model do
  subject(:branch) { supplier.branches.build(postcode: 'SW1A 1AA') }

  let(:supplier) { Supplier.new }

  it { is_expected.to be_valid }

  it 'is not valid if postcode is blank' do
    branch.postcode = ''
    expect(branch).not_to be_valid
  end

  context 'when postcode is nonsense' do
    before do
      branch.postcode = 'nonsense'
    end

    it { is_expected.not_to be_valid }

    it 'has a sensible error message' do
      branch.validate
      expect(branch.errors).to include(postcode: include('is not a valid postcode'))
    end
  end
end
