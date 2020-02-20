require 'csv'
require 'rails_helper'
require 'fm_calculator/calculator'

# rubocop:disable all

RSpec.describe FMCalculator::Calculator do
  subject(:calculator) do
  end

  let(:json_test_data) { JSON.parse(file_fixture('fm-calculator-test-data.json').read, symbolize_names: false) }
  let(:csv_test_data) { CSV.parse(file_fixture('fm-calculator-test-data.csv').read, headers: true) }

  before do
    @rates = CCS::FM::Rate.read_benchmark_rates
  end

  describe 'FM Calculator' do
    it 'FMCalculator for basic math using CSV' do
      csv_table = csv_test_data
      rates = @rates

      csv_table.each do |row|
        method_to_call = row['expectation_name']
        puts "Test #{row['test_name']}: #{method_to_call}"
        
        calculator = Object.const_get("FMCalculator::Calculator").method('new').call(
          row['contract_length_years'].to_i, row['service_ref'], row['uom_vol'].to_i, row['occupants'].to_i, row['tupe_flag'] == 'true', row['london_flag'], row['cafm_flag'], row['helpdesk_flag'], rates
        )
        
        result = calculator.__send__(method_to_call.to_sym)
        
        expect(result.round(0)).to eq(row['expectation_value'].to_i)
      end
    end

    it 'FMCalculator for basic math using JSON' do
      json_data = json_test_data['tests']
      
      rates = json_test_data['rates'] || @rates
  
      json_data.each do |test|
        puts test['test_name']

        calculator = Object.const_get("FMCalculator::Calculator").method('new').call(
          test['contract_length_years'].to_i, test['service_ref'], test['uom_vol'].to_i, test['occupants'].to_i, test['tupe_flag'] == 'true', test['london_flag'], test['cafm_flag'], test['helpdesk_flag'], rates
        )

        test['expectations'].each do |method_name, expect_value|
          result = calculator.__send__(method_name.to_sym)
  
          expect(result.round(0)).to eq(expect_value.to_i)
        end
        
      end
    end
  end
end
# rubocop:enable all
