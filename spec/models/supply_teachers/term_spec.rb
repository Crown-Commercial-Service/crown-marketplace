require 'rails_helper'

RSpec.describe SupplyTeachers::Term, type: :model do
  subject(:terms) { described_class.all }

  let(:first_term) { terms.first }
  let(:all_codes) { terms.map(&:code) }

  it 'loads terms from CSV' do
    expect(terms.count).to eq(5)
  end

  it 'populates attributes of first term' do
    expect(first_term.code).to eq('0_1')
    expect(first_term.description).to eq('Up to 1 week')
  end

  it 'only has unique codes' do
    expect(all_codes.uniq).to contain_exactly(*all_codes)
  end

  it 'all have descriptions' do
    expect(terms.select { |r| r.description.blank? }).to be_empty
  end
end
