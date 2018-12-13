require 'rails_helper'

RSpec.describe SupplyTeachers::RateTerm, type: :model do
  subject(:rate_terms) { described_class.all }

  let(:first_rate_term) { rate_terms.first }

  it 'loads rate_terms from CSV' do
    expect(rate_terms.count).to eq(3)
  end

  it 'populates attributes of first rate_term' do
    expect(first_rate_term.code).to eq('one_week')
    expect(first_rate_term.description).to eq('Up to 1 week')
  end

  describe '.[]' do
    it 'looks up rate term description by code' do
      expect(described_class['one_week']).to eq('Up to 1 week')
    end
  end

  describe '.all_codes' do
    it 'returns codes for all rate_terms' do
      expect(described_class.all_codes.count).to eq(rate_terms.count)
      expect(described_class.all_codes.first).to eq(first_rate_term.code)
    end
  end
end
