require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::ServiceSpecificationParser do
  subject(:service_specification) { described_class.new(work_package_code, service_code) }

  describe 'regular expressions' do
    context 'when parsing in the service line' do
      [
        '1.     Service A:1 - Integration',
        '1.1.   The following Standards Ref apply to this Service - SA1.',
        '1.5.1. Focus on cross / multi-skilling',
        '1.5.5. Be alert and provide the benefits',
        '1.6.   The Supplier shall work collaboratively',
        '1.6.1. Use of intelligent software to monitor',
        '1.7.   The Supplier shall ensure that all opportunities',
        '1.8.   The Supplier shall ensure that the initiatives',
        "1.8.2. Recorded within the Supplier's CAFM system; and",
      ].each do |line|
        it "extracts service code from: #{line}" do
          result = line.match(described_class::SERVICE_LINE_REGEX)
          expect(result.class).to eq(MatchData)
          expect(result[0]).to match(/\A(\d+.)+\z/)
        end
      end
    end
  end

  describe '.new' do
    let(:work_package_service_lines) { service_specification.work_package_service_lines }
    let(:service_lines) { service_specification.service_lines }

    context 'when work package service lines' do
      let(:work_package_code) { 'G' }
      let(:service_code) { 'G.1' }

      it 'has no work package service line' do
        expect(work_package_service_lines).to be_nil
      end

      it 'has correct service heading' do
        expect(service_lines.first[:body]).to eq('Service G1 - Hard Landscaping Services')
      end

      it 'has correct number of service lines' do
        expect(service_lines.size).to eq(18)
      end

      it 'has correct clause structure' do
        expect(service_lines.first.keys).to eq(%i[numbers body])
      end
    end

    context 'when work package has a generic part' do
      let(:work_package_code) { 'F' }
      let(:service_code) { 'F.1' }

      it 'has no work package service line' do
        expect(work_package_service_lines).to be_any
      end

      it 'has correct number of generic clauses' do
        expect(work_package_service_lines.size).to eq(7)
      end
    end
  end

  describe '.split_service_lines' do
    let(:work_package_code) { 'D' }
    let(:service_code) { 'D.1' }
    let(:result) { service_specification.send(:split_service_lines, unformatted_service_lines) }

    context 'when there are numbers for all service lines' do
      let(:unformatted_service_lines) do
        [
          '80.   Service I:5 – Deep (periodic) cleaning',
          '80.1.     The following Standards Ref apply to this Service - SI5.',
          '80.2.     The Supplier shall: ',
          '80.2.1.    Provide a programme for periodic and Deep Cleaning activities to the Buyer for Approval within one Month of the start of each Contract Year;'
        ]
      end

      it 'returns the service lines formatted correctly' do
        expect(result).to eq [
          { numbers: ['80'],            body: 'Service I:5 – Deep (periodic) cleaning' },
          { numbers: ['80', '1'],       body: 'The following Standards Ref apply to this Service - SI5.' },
          { numbers: ['80', '2'],       body: 'The Supplier shall:' },
          { numbers: ['80', '2', '1'],  body: 'Provide a programme for periodic and Deep Cleaning activities to the Buyer for Approval within one Month of the start of each Contract Year;' },
        ]
      end
    end

    context 'when there are no numbers for all service lines' do
      let(:unformatted_service_lines) do
        [
          '130.             L.15 - Blended Static Guarding Service',
          'Static Guarding Services ',
          '130.1.     The following Standards Ref apply to this Service - SL15. ',
          '130.2.     The Supplier shall provide a comprehensive security servcie across Buyer Premises that will include the following duties:',
          '130.2.1.     The operation of building access control systems for people and vehicles, into Buyer Premises to prevent unauthorised access;'
        ]
      end

      it 'returns the service lines formatted correctly' do
        expect(result).to eq [
          { numbers: ['130'],           body: 'L.15 - Blended Static Guarding Service' },
          { numbers: [],                body: 'Static Guarding Services' },
          { numbers: ['130', '1'],      body: 'The following Standards Ref apply to this Service - SL15.' },
          { numbers: ['130', '2'],      body: 'The Supplier shall provide a comprehensive security servcie across Buyer Premises that will include the following duties:' },
          { numbers: ['130', '2', '1'], body: 'The operation of building access control systems for people and vehicles, into Buyer Premises to prevent unauthorised access;' },
        ]
      end
    end
  end
end
