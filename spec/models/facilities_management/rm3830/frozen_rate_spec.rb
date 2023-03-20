require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::FrozenRate do
  subject(:frozen_rate) { described_class.new(facilities_management_rm3830_procurement_id: procurement.id, code: 'abc', framework: 1.2, benchmark: 2.2, standard: 'Y', direct_award: false) }

  before { frozen_rate.save }

  let(:procurement) { create(:facilities_management_rm3830_procurement, user:) }
  let(:user) { create(:user) }

  it 'has no benchmark rates' do
    rates = described_class.read_benchmark_rates
    expect(rates[:benchmark_rates]['abc-Y']).to eq 2.2
    expect(rates[:framework_rates]['abc-Y']).to eq 1.2
  end
end
