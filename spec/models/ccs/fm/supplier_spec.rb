require 'rails_helper'

RSpec.describe CCS::FM::Supplier, type: :model do


  # SELECT distinct data->>'supplier_name' as "name", lots->>'services' as  "service_code",
  # lots->>'regions' as "region_code" from fm_suppliers,
  # jsonb_array_elements(fm_suppliers.data -> 'lots') lots,
  # jsonb_array_elements(lots -> 'regions') regions,
  # jsonb_array_elements(lots->'services') services  
  # where regions in ('"UKC1"','"UKM21"') 
  # and services in ('"C.1"') 
  # and  lots -> 'lot_number' in ( '"1a"' )
  # group by name, service_code, region_code order by data->>'supplier_name'
  it 'can select suppliers for a given lot, regions and services' do

    for_lot = '1a'
    for_regions = []
    for_services = []
    vals = CCS::FM::Supplier.selected_suppliers(for_lot, ['UKC1','UKM21'], ['C.1'])

    p vals.count

    expect(vals.count).to be > 0
  end

end