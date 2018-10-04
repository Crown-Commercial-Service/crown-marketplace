require 'rails_helper'

RSpec.describe Supplier, type: :model do
  subject(:supplier) { described_class.new(name: 'supplier-name') }

  it { is_expected.to be_valid }

  it 'is not valid if name is blank' do
    supplier.name = ''
    expect(supplier).not_to be_valid
  end
end
