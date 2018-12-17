require 'rails_helper'

RSpec.describe SupplyTeachers::SchoolType, type: :model do
  let(:all_ids) { described_class.all.map(&:id) }

  it 'only has unique ids' do
    expect(all_ids.uniq).to contain_exactly(*all_ids)
  end

  context 'when it is a state school' do
    subject { described_class.find_by(id: '01') }

    it { is_expected.to be_non_profit }
  end

  context 'when it is an independent school' do
    subject { described_class.find_by(id: '10') }

    it { is_expected.not_to be_non_profit }
  end
end
