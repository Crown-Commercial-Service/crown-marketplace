require 'rails_helper'

RSpec.describe CCS::FM::FrozenRate, type: :model do
  subject(:frozen_rate) { CCS::FM::FrozenRate.new(facilities_management_procurement_id: procurement.id, code: 'abc', framework: 1.2, benchmark: 2.2, standard: 'Y', direct_award: false) }

  before { frozen_rate.save }

  let(:procurement) { create(:facilities_management_procurement, user: user) }
  let(:user) { create(:user) }

  it 'has no benchmark rates' do
    rates = CCS::FM::FrozenRate.read_benchmark_rates
    expect(rates[:benchmark_rates]['abc-Y']).to eq 2.2
    expect(rates[:framework_rates]['abc-Y']).to eq 1.2
  end
end
