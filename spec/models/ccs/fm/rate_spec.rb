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
end
