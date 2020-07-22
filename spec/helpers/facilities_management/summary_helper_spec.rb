require 'rails_helper'

RSpec.describe FacilitiesManagement::SummaryHelper, type: :helper do
  describe 'calculate vom value' do
    context 'when uom is an integer' do
      it 'will return the integer' do
        val = {}
        val[:uom_value] = 10
        expect(calculate_uom_value(val)).to eq 10
      end

      it 'will return the integer for a string input' do
        val = {}
        val[:uom_value] = '20'
        expect(calculate_uom_value(val)).to eq 20
      end
    end

    context 'when uom is not a String or Numeric' do
      it 'will return nil' do
        val = {}
        val[:uom_value] = {}
        expect(calculate_uom_value(val)).to be nil
      end
    end
  end
end
