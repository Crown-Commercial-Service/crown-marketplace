require 'rails_helper'

RSpec.describe FacilitiesManagement::SecurityTypes, type: :model do
  describe '#SecurityTypes' do
    context 'when constructing, expect a result' do
      it 'is not nil' do
        s = described_class.new
        expect(s).not_to eq nil
      end
    end

    context 'when accessing the database' do
      it 'returns a collection or rows' do
        expect(described_class.first.blank?).to eq false
      end
    end
  end
end
