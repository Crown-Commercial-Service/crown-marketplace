require 'rails_helper'

RSpec.describe CCS::FM::Supplier, type: :model do
  it 'can select suppliers for a given lot, regions and services' do
    for_lot = '1a'
    for_regions = ['UKC1', 'UKM21']
    for_services = ['C.1', 'L.1']
    vals = CCS::FM::Supplier.selected_suppliers(for_lot, for_regions, for_services)

    expect(vals.count).to be > 0
  end
end
