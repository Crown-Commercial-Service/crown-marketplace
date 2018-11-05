require 'rails_helper'

RSpec.describe FacilitiesManagementLot, type: :model do
  subject(:lots) { described_class.all }

  let(:first_lot) { lots.first }

  it 'loads lots from CSV' do
    expect(lots.count).to eq(3)
  end

  it 'populates attributes of first lot' do
    expect(first_lot.number).to eq('1a')
    expect(first_lot.description).to eq('Total contract value up to £7M')
  end
end
