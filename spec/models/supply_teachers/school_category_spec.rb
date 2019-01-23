require 'rails_helper'

RSpec.describe SupplyTeachers::SchoolCategory, type: :model do
  let(:school_categories) { described_class.all }
  let(:all_ids) { school_categories.map(&:id) }

  it 'only has unique ids' do
    expect(all_ids.uniq).to contain_exactly(*all_ids)
  end

  it 'all have names' do
    expect(school_categories.select { |st| st.name.blank? }).to be_empty
  end

  it 'all have boolean non_profit attribute' do
    expect(school_categories.reject { |st| [TrueClass, FalseClass].include?(st.non_profit.class) }).to be_empty
  end
end
