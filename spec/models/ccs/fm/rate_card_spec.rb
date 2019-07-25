require 'rails_helper'

RSpec.describe CCS::FM::RateCard, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it 'can contain entries' do
    expect(CCS::FM::RateCard.count).to be > 0
  end

  it 'contains data' do
    expect(CCS::FM::RateCard.latest.data['Prices'].count).to be > 0
    expect(CCS::FM::RateCard.latest.data['Discounts'].count).to be > 0
    expect(CCS::FM::RateCard.latest.data['Variances'].count).to be > 0
  end

  it 'can retrieve latest entry' do
    is_this_the_last_dated_record = CCS::FM::RateCard.latest
    actual_last_record = CCS::FM::RateCard.where(updated_at: CCS::FM::RateCard.select('max(updated_at)')).first

    expect(is_this_the_last_dated_record.source_file).to eq(actual_last_record.source_file)
    expect(is_this_the_last_dated_record.id).to eq(actual_last_record.id)
    expect(is_this_the_last_dated_record.updated_at).to eq(actual_last_record.updated_at)
  end

  it 'contains rates for services' do
    rate_card = CCS::FM::RateCard.latest

    # sheet_name == 'Prices'
    # data['Prices'][rate_card['Supplier']][rate_card['Service Ref']] = rate_card
    prices = rate_card.data['Prices'].keys.map { |k| rate_card.data['Prices'][k]['C.1'] }
    expect(prices.count).to be > 0

    # sheet_name == 'Discount'
    # data['Discount'][rate_card['Supplier']][rate_card['Ref']] = rate_card
    discount = rate_card.data['Discounts'].keys.map { |k| rate_card.data['Discounts'][k]['C.1'] }
    expect(discount.count).to be > 0

    # sheet_name == 'Variances'
    # data['Variances'][rate_card['Supplier']] = rate_card
    variances = rate_card.data['Variances'].keys.map { |k| rate_card.data['Discounts'][k] }
    expect(variances.count).to be > 0
  end
end
