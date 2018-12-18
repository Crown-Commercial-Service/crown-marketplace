require 'rails_helper'

RSpec.describe SupplyTeachers::SchoolType, type: :model do
  let(:school_types) { described_class.all }
  let(:all_ids) { school_types.map(&:id) }

  it 'only has unique ids' do
    expect(all_ids.uniq).to contain_exactly(*all_ids)
  end

  it 'all have names' do
    expect(school_types.select { |st| st.name.blank? }).to be_empty
  end

  it 'all have boolean non_profit attribute' do
    expect(school_types.reject { |st| [TrueClass, FalseClass].include?(st.non_profit.class) }).to be_empty
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
