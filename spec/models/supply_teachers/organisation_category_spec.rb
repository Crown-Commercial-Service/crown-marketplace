require 'rails_helper'

RSpec.describe SupplyTeachers::OrganisationCategory, type: :model do
  let(:organisation_categories) { described_class.all }
  let(:all_ids) { organisation_categories.map(&:id) }

  it 'only has unique ids' do
    expect(all_ids.uniq).to contain_exactly(*all_ids)
  end

  it 'all have names' do
    expect(organisation_categories.select { |st| st.name.blank? }).to be_empty
  end

  it 'all have boolean non_profit attribute' do
    expect(organisation_categories.reject { |st| [TrueClass, FalseClass].include?(st.non_profit.class) }).to be_empty
  end
end
