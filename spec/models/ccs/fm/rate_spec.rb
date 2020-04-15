require 'rails_helper'

RSpec.describe CCS::FM::Rate, type: :model do
  it 'contains data' do
    benchmark_rates = {}
    framework_rates = {}
    CCS::FM::Rate.all.each do |row|
      code = row['code'].remove('.')
      benchmark_rates[code] = row['benchmark'].to_f
      framework_rates[code] = row['framework'].to_f
    end

    expect(benchmark_rates.count).to be > 0
    expect(framework_rates.count).to be > 0
  end

  it 'has benchmark rates' do
    rates = CCS::FM::Rate.read_benchmark_rates

    expect(rates[:benchmark_rates].count).to be > 0
    expect(rates[:framework_rates].count).to be > 0
  end

  describe 'framework and benchmark rates' do
    context 'when rate has standard A' do
      let(:code) { 'C.1' }
      let(:standard) { 'A' }

      it 'returns standard A framework rate' do
        expect(described_class.framework_rate_for(code, standard)).to eq(CCS::FM::Rate.find_by(code: code, standard: standard).framework)
      end

      it 'returns standard A benchmark rate' do
        expect(described_class.benchmark_rate_for(code, standard)).to eq(CCS::FM::Rate.find_by(code: code, standard: standard).benchmark)
      end
    end

    context 'when rate has standard B' do
      let(:code) { 'C.1' }
      let(:standard) { 'B' }

      it 'returns standard B framework rate' do
        expect(described_class.framework_rate_for(code, standard)).to eq(CCS::FM::Rate.find_by(code: code, standard: standard).framework)
      end

      it 'returns standard B benchmark rate' do
        expect(described_class.benchmark_rate_for(code, standard)).to eq(CCS::FM::Rate.find_by(code: code, standard: standard).benchmark)
      end
    end

    context 'when rate has standard C' do
      let(:code) { 'C.1' }
      let(:standard) { 'C' }

      it 'returns standard C framework rate' do
        expect(described_class.framework_rate_for(code, standard)).to eq(CCS::FM::Rate.find_by(code: code, standard: standard).framework)
      end

      it 'returns standard C benchmark rate' do
        expect(described_class.benchmark_rate_for(code, standard)).to eq(CCS::FM::Rate.find_by(code: code, standard: standard).benchmark)
      end
    end

    context 'when rate does not have standards' do
      let(:code) { 'G.9' }

      it 'returns framework rate' do
        expect(described_class.framework_rate_for(code)).to eq(CCS::FM::Rate.find_by(code: code).framework)
      end

      it 'returns benchmark rate' do
        expect(described_class.benchmark_rate_for(code)).to eq(CCS::FM::Rate.find_by(code: code).benchmark)
      end
    end
  end
end
