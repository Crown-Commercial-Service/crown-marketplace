require 'rails_helper'

RSpec.describe CCS::FM::FrozenRateCard, type: :model do
  subject(:frozen_date_card) { CCS::FM::FrozenRateCard.new(facilities_management_procurement_id: procurement.id, data: { 'foo' => 'bar', 'level1' => { 'level2' => 'baz' } }, source_file: 'path') }

  let(:procurement) { create(:facilities_management_procurement, user: user) }
  let(:user) { create(:user) }

  before { frozen_date_card.save }

  it 'has data' do
    rate_card = CCS::FM::FrozenRateCard.latest
    expect(rate_card.data.size).to eq 2
  end
end
