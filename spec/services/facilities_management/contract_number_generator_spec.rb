require 'rails_helper'

RSpec.describe FacilitiesManagement::ContractNumberGenerator do
  let(:contract_number_generator) { described_class.new(procurement_state: procurement_state, framework: framework, used_numbers: []) }

  describe '.new_number' do
    context 'with a RM3830 framework' do
      let(:framework) { 'RM3830' }

      context 'with a procurement in direct_award' do
        let(:procurement_state) { :direct_award }

        it 'has the correct format' do
          expect(contract_number_generator.new_number).to match(/\ARM3830-DA\d{4}-\d{4}\z/)
        end

        it 'has the current year as the final 4 digits' do
          current_year = Date.current.year.to_s

          expect(contract_number_generator.new_number.split('-')[2]).to eq(current_year)
        end
      end

      context 'with a procurement going to further_competition' do
        let(:procurement_state) { :further_competition }

        it 'has the correct format' do
          expect(contract_number_generator.new_number).to match(/\ARM3830-FC\d{4}-\d{4}\z/)
        end

        it 'has the current year as the final 4 digits' do
          current_year = Date.current.year.to_s

          expect(contract_number_generator.new_number.split('-')[2]).to eq(current_year)
        end
      end
    end

    context 'with an RM6232 framework' do
      let(:framework) { 'RM6232' }

      context 'with a procurement in direct_award' do
        let(:procurement_state) { :direct_award }

        it 'has the correct format' do
          expect(contract_number_generator.new_number).to match(/\ARM6232-DA\d{4}-\d{4}\z/)
        end

        it 'has the current year as the final 4 digits' do
          current_year = Date.current.year.to_s

          expect(contract_number_generator.new_number.split('-')[2]).to eq(current_year)
        end
      end

      context 'with a procurement going to further_competition' do
        let(:procurement_state) { :further_competition }

        it 'has the correct format' do
          expect(contract_number_generator.new_number).to match(/\ARM6232-FC\d{4}-\d{4}\z/)
        end

        it 'has the current year as the final 4 digits' do
          current_year = Date.current.year.to_s

          expect(contract_number_generator.new_number.split('-')[2]).to eq(current_year)
        end
      end
    end
  end
end
