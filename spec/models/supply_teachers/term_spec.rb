require 'rails_helper'

RSpec.describe SupplyTeachers::Term, type: :model do
  subject(:terms) { described_class.all }

  let(:first_term) { terms.first }

  it 'loads terms from CSV' do
    expect(terms.count).to eq(5)
  end

  it 'populates attributes of first term' do
    expect(first_term.code).to eq('0_1')
    expect(first_term.description).to eq('Up to 1 week')
  end
end
