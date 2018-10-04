require 'rails_helper'

RSpec.describe Branch, type: :model do
  subject(:branch) { supplier.branches.build(postcode: 'SW1A 1AA') }

  let(:supplier) { Supplier.new }

  it { is_expected.to be_valid }

  it 'is not valid if postcode is blank' do
    branch.postcode = ''
    expect(branch).not_to be_valid
  end
end
