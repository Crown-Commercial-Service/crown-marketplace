require 'rails_helper'

RSpec.describe CCS::FM::RateCard, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it 'can contain entries' do
    expect(CCS::FM::RateCard.count).to be > 0
  end

  it 'contains data' do
    expect(CCS::FM::RateCard.last.data['Prices'].count).to be > 0
    expect(CCS::FM::RateCard.last.data['Discount'].count).to be > 0
    expect(CCS::FM::RateCard.last.data['Variances'].count).to be > 0
  end

  it 'can retrieve latest entry' do
    is_this_the_last_dated_record = CCS::FM::RateCard.last
    actual_last_record = CCS::FM::RateCard.where(updated_at: CCS::FM::RateCard.select('max(updated_at)'))

    expect(is_this_the_last_dated_record.id).to eq(actual_last_record.first.id)
    expect(is_this_the_last_dated_record.updated_at).to eq(actual_last_record.first.updated_at)
  end
end
