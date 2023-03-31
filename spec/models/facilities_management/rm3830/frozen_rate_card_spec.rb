require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::FrozenRateCard do
  subject(:frozen_date_card) { described_class.new(facilities_management_rm3830_procurement_id: procurement.id, data: { 'foo' => 'bar', 'level1' => { 'level2' => 'baz' } }, source_file: 'path') }

  let(:procurement) { create(:facilities_management_rm3830_procurement, user:) }
  let(:user) { create(:user) }

  before { frozen_date_card.save }

  it 'has data' do
    rate_card = described_class.latest
    expect(rate_card.data.size).to eq 2
  end
end
