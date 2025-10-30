require 'rails_helper'

RSpec.describe Lot do
  describe 'associations' do
    let(:lot) { create(:lot) }

    it { is_expected.to belong_to(:framework) }
    it { is_expected.to have_many(:services) }
    it { is_expected.to have_many(:supplier_framework_lots) }
    it { is_expected.to have_many(:procurements) }

    it 'has the framework relationship' do
      expect(lot.framework).to be_present
    end
  end

  describe '.services_grouped_by_category' do
    let(:lot) { described_class.find(lot_id) }
    let(:services) { Service.where(lot_id:) }

    context 'when the lot does not have categories' do
      let(:lot_id) { 'RM6309.2' }

      it 'is expected to find the correct services for a normal lot' do
        expect(lot.services_grouped_by_category).to eq([[nil, services.sort_by(&:name)]])
      end
    end

    context 'when the lot does have categories' do
      let(:lot_id) { 'RM6309.10' }

      it 'is expected to find the correct services for a normal lot' do
        primary_services = services[0..6].sort_by(&:name)
        additional_services = services[7..12].sort_by(&:name)
        sector_services = services[13..].sort_by(&:name)

        expect(lot.services_grouped_by_category).to eq(
          [
            ['Primary capabilities', primary_services],
            ['Additional capabilities', additional_services],
            ['Sector specialisms', sector_services]
          ]
        )
      end
    end
  end

  describe '.positions_grouped_by_name' do
    let(:lot) { described_class.find(lot_id) }
    let(:positions) { Position.where(lot_id:) }
    let(:lot_id) { 'RM6238.1' }

    # rubocop:disable RSpec/ExampleLength
    it 'is expected to find the correct categories' do
      expect(lot.positions_grouped_by_name).to eq(
        [
          ['teacher', positions[0..1].sort_by(&:number)],
          ['support', positions[2..3].sort_by(&:number)],
          ['senior', positions[4..5].sort_by(&:number)],
          ['other', positions[6..7].sort_by(&:number)],
          ['over_12_week', positions[8..8].sort_by(&:number)],
          ['nominated', positions[9..9].sort_by(&:number)],
          ['fixed_term', positions[10..10].sort_by(&:number)],
        ]
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
