require 'rails_helper'

RSpec.describe ManagementConsultancy::JourneyHelper, type: :helper do
  describe '#lot_number_and_description' do
    it 'returns the full title with lot and description' do
      lot_number = 'MCF1.2'
      description = 'Business consultancy'

      expect(helper.lot_number_and_description(lot_number, description)).to eq('Lot 2 - Business consultancy')
    end
  end

  describe '#framework_lot_and_description' do
    context 'when the lot is in MCF' do
      it 'returns the full title with lot, framework and description' do
        lot_number = 'MCF1.2'
        description = 'Business consultancy'

        expect(helper.framework_lot_and_description(lot_number, description)).to eq('MCF lot 2 - Business consultancy')
      end
    end

    context 'when the lot is in MCF2' do
      it 'returns the full title with lot, framework and description' do
        lot_number = 'MCF2.1'
        description = 'Procurement'

        expect(helper.framework_lot_and_description(lot_number, description)).to eq('MCF2 lot 1 - Procurement')
      end
    end
  end
end
