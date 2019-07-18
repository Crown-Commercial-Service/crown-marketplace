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
    is_this_the_last_dated_record = CCS::FM::RateCard.latest
    actual_last_record = CCS::FM::RateCard.where(updated_at: CCS::FM::RateCard.select('max(updated_at)'))

    expect(is_this_the_last_dated_record.id).to eq(actual_last_record.first.id)
    expect(is_this_the_last_dated_record.updated_at).to eq(actual_last_record.first.updated_at)
  end

  it 'contains rates for services' do
    rate_card = CCS::FM::RateCard.last

    # sheet_name == 'Prices'
    # data['Prices'][rate_card['Supplier']][rate_card['Service Ref']] = rate_card
    prices = rate_card.data['Prices'].keys.map { |k| rate_card.data['Prices'][k]['C.1'] }
    expect(prices.count).to be > 0

    # sheet_name == 'Discount'
    # data['Discount'][rate_card['Supplier']][rate_card['Ref']] = rate_card
    discount = rate_card.data['Discount'].keys.map { |k| rate_card.data['Discount'][k]['C.1'] }
    expect(discount.count).to be > 0

    # sheet_name == 'Variances'
    # data['Variances'][rate_card['Supplier']] = rate_card
    variances = rate_card.data['Variances'].keys.map { |k| rate_card.data['Discount'][k] }
    expect(variances.count).to be > 0
  end
end
