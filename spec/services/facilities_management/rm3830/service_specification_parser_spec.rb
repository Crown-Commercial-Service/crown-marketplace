require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ServiceSpecificationParser do
  subject(:service_specification) { described_class.new.call(service_code, work_package_code) }

  describe 'regular expressions' do
    describe 'new service' do
      [
        '58.   Service A:1- Building Information',
        '58.   Service A:1 - Building Information',
        '58.   Service A::1 - Building Information',
        '58.   Service A::1- Building Information'
      ].each do |line|
        it "extracts service code from: #{line}" do
          result = line.match(described_class::SERVICE_REGEX)
          expect(result.class).to eq(MatchData)
          expect(result[1]).to match(/A:+1/)
        end
      end
    end
  end

  describe '#call' do
    context 'when work package has no generic part' do
      let(:work_package_code) { 'A' }
      let(:service_code) { 'A.1' }

      it 'has correct keys' do
        expect(service_specification.keys).to eq(%i[work_package service])
      end

      it 'has correct work package heading' do
        expect(service_specification[:work_package][:heading]).to eq('Work Package A - Contract Management')
      end

      it 'has empty generic' do
        expect(service_specification[:work_package][:generic]).to be_empty
      end

      it 'has correct service heading' do
        expect(service_specification[:service][:heading]).to eq('Service A:1 - Integration')
      end

      it 'has correct number of service clauses' do
        expect(service_specification[:service][:clauses].size).to eq(20)
      end

      it 'has correct clause structure' do
        expect(service_specification[:service][:clauses].first.keys).to eq(%i[number body])
      end
    end

    context 'when work package has generic part' do
      let(:work_package_code) { 'C' }
      let(:service_code) { 'C.2' }

      it 'has correct work package heading' do
        expect(service_specification[:work_package][:heading]).to eq('Work Package C - Maintenance Services')
      end

      it 'has correct generic heading' do
        expect(service_specification[:work_package][:generic][:heading]).to eq('Generic maintenance requirements')
      end

      it 'has correct number of generic clauses' do
        expect(service_specification[:work_package][:generic][:clauses].size).to eq(31)
      end
    end
  end

  describe '#split_number_and_clause' do
    subject(:parser) { described_class.new }

    it 'handles non-ascii whitespace' do
      str = parser.send(:sanitize, '42.2.9.    Calibration and maintenance of language laboratory equipment abc;')
      expect(parser.send(:split_number_and_clause, str)[:number]).to eq('42.2.9.')
    end

    it 'handles no space after number' do
      str = parser.send(:sanitize, '42.2.The Supplier shall be responsible for undertaking inspections and all xyz')
      expect(parser.send(:split_number_and_clause, str)[:number]).to eq('42.2.')
    end

    it 'handles no number' do
      str = parser.send(:sanitize, 'A heading')
      expect(parser.send(:split_number_and_clause, str)[:number]).to be_nil
      expect(parser.send(:split_number_and_clause, str)[:body]).to eq(str)
    end
  end
end
