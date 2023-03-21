require 'rails_helper'

RSpec.describe FacilitiesManagement::SecurityType do
  describe '#SecurityType' do
    context 'when constructing, expect a result' do
      it 'is not nil' do
        s = described_class.new
        expect(s).not_to be_nil
      end
    end

    context 'when accessing the database' do
      it 'returns a collection or rows' do
        expect(described_class.first.blank?).to be false
      end
    end
  end
end
