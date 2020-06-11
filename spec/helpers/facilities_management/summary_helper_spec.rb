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

    context 'when uom is the service hours for each work day' do
      it 'will return the addition of all the values * 52' do
        val = {}
        val[:uom_value] = {}
        value = 1
        Date::DAYNAMES.each do |day|
          val[:uom_value][day.downcase.to_sym] = {}
          val[:uom_value][day.downcase.to_sym][:uom] = value
          value += 1
        end
        result_value = (1 + 2 + 3 + 4 + 5 + 6 + 7) * 52
        expect(calculate_uom_value(val)).to eq result_value
      end

      it 'will round value to 2 digits' do
        val = {}
        val[:uom_value] = {}
        value = 1
        Date::DAYNAMES.each do |day|
          val[:uom_value][day.downcase.to_sym] = {}
          val[:uom_value][day.downcase.to_sym][:uom] = value
          value += 1
        end
        val[:uom_value][:sunday][:uom] = 2.56789
        expect(calculate_uom_value(val)).to eq(((2.56789 + 2 + 3 + 4 + 5 + 6 + 7) * 52).round(2))
      end
    end
  end
end
