require 'rails_helper'

RSpec.describe FacilitiesManagement::SecurityTypes, type: :model do
  describe '#SecurityTypes' do
    context 'when constructing, expect a result' do
      it 'is not nil' do
        s = FacilitiesManagement::SecurityTypes.new
        expect(s).not_to eq nil
      end
    end

    context 'data validation' do
      it 'returns a collection or rows' do
        expect(FacilitiesManagement::SecurityTypes.first.blank?).to eq false
      end
    end
  end
end
