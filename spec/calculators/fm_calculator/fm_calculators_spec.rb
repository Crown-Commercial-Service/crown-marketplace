require 'csv'
require 'rails_helper'
require 'fm_calculator/calculator'

# rubocop:disable all

RSpec.describe FMCalculator::Calculator do
  subject(:calculator) do
  end
  
  let(:json_test_data) { JSON.parse(file_fixture('fm-calculator-test-specifications.json').read, symbolize_names: false) }
  let(:csv_test_data) { CSV.parse(file_fixture('fm-calculator-test-data-3.csv').read, headers: true) }
  
  before do
    @rates = CCS::FM::Rate.read_benchmark_rates
  end
  
  describe 'FM Calculator' do
    it 'FMCalculator for basic math using CSV' do
      csv_table = csv_test_data
      rates     = @rates
      
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
    
    it 'computes test from JSON specifications' do
      json_test_data['fixtures'].each do |fixture_name|
        fixture   = json_test_data[fixture_name]
        test_data = JSON.parse(file_fixture(fixture['test']).read)
        
        rates = json_test_data['rates'] || @rates
        
        test_data.each do |test|
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
    
    describe 'spreadsheet parsing' do
      context 'parsing reduced CSV' do
        it 'will create JSON data' do
          csv_table = CSV.parse(file_fixture('fm-calculator-test-data-3.csv').read, headers: true)
          json_data = []
          status    = {
            expectation_name: ''
          }
          
          csv_table.each do |reduced_row|
            json_data << create_json_from(reduced_row, status)
          end
          
          expect(json_data.count).to eq(csv_table)
          puts json_data
        end
      end
      
      context 'parsing direct CSV' do
        let(:spreadsheet_property_map) {
          {
            test_name:             {
              col_num:  0,
              col_name: 'Customer\'s Buildings/Services'
            },
            contract_length_years: 1,
            service_name:          {
              col_num:  2,
              col_name: 'Service Name'
            },
            service_ref:           {
              col_num:  1,
              col_name: 'Service reference'
            },
            uom_vol:               {
              col_num:  4,
              col_name: 'UoM volume'
            },
            occupants:             {
              col_num:  5,
              col_name: 'Number of Building Occupants'
            },
            tupe_flag:             {
              col_num:  6,
              col_name: 'TUPE involved?'
            },
            london_flag:           {
              col_num:  7,
              col_name: 'London location'
            },
            cafm_flag:             {
              col_num:  8,
              col_name: 'CAFM (M.1)'
            },
            helpdesk_flag:         {
              col_num:  9,
              col_name: 'Helpdesk (N.1)'
            },
            expectations:          {
            
            }
          }
        }
        
        it 'will parse assessed value spreadsheet and create tests' do
          spreadsheet_property_map[:contract_length_years]              = 6
          spreadsheet_property_map[:expectations][:sumunitofmeasure]    = {
            col_num:  31,
            col_name: 'Total Charges'
          }
          spreadsheet_property_map[:expectations][:benchmarkedcostssum] = {
            col_num:  49,
            col_name: 'Total Charges'
          }
          
          csv_input = CSV.parse(file_fixture('fm-calculator-test-data-3_direct.csv').read, headers: true)
          json_data = process_direct_csv_input(
            csv_input,
            spreadsheet_property_map
          )
          
          expect(json_data.count).to eq(csv_input.count)
          puts json_data
        end
      end
      
      def process_direct_csv_input(csv_table, property_map)
        json_data = []
        status    = {
          in_expectations_list: false,
          expectation_name:     ''
        }
        
        csv_table.each do |direct_row|
          json_data << create_json_from(reduce(direct_row, property_map), status)
        end
        
        json_data
      end
      
      def reduce(direct_row, property_map)
        cells = []
        direct_row.each_with_index do |cell, index|
          cells << [:contract_length_years, property_map[:contract_length_years]] if index == 1
          translated_cell = property_map.select { |k, v| v.is_a?(Hash) && k != :expectations ? cell[0].start_with?(v[:col_name]) && index == v[:col_num] : k == cell[0] }
          translated_cell = [translated_cell.first[0], cell[1]] if translated_cell.present?
          translated_cell = [cell[0], cell[1]] if translated_cell.nil?
          cells << translated_cell if translated_cell.present?
        end
        
        property_map[:expectations].each do |k, v|
          expectation_name  = ['expectation_name', k.to_s]
          expectation_value = ['expectation_value', direct_row[v[:col_num]][1..100000]]
          cells << expectation_name
          cells << expectation_value
        end
        
        cells
      end
      
      def create_json_from(row, status)
        hash                 = {}
        hash['expectations'] = {}
        row.each do |cell|
          hash[cell[0]] = cell[1] unless %w[expectation_name expectation_value].include? cell[0]
          if cell[0] == 'expectation_name'
            hash['expectations']["#{cell[1]}"] = 0
            status[:expectation_name]          = cell[1]
          end
          if cell[0] == 'expectation_value'
            hash['expectations'][status[:expectation_name]] = cell[1]
          end
        end
        
        hash
      end
    end
  end
end
# rubocop:enable all
