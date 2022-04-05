require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Supplier, type: :model do
  describe '.lot_data' do
    context 'when selecting a random supplier' do
      let(:supplier) { described_class.order(Arel.sql('RANDOM()')).first }

      it 'has lot data' do
        expect(supplier.lot_data.class.to_s).to eq 'FacilitiesManagement::RM6232::Supplier::LotData::ActiveRecord_Associations_CollectionProxy'
      end
    end

    context 'when looking at a supplier' do
      it 'has some lot data' do
        expect(described_class.find(described_class.pluck(:id).sample).lot_data.count).to be >= 1
      end
    end
  end
end
