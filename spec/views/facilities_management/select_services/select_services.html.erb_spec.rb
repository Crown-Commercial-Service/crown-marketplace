require 'rails_helper'
require 'json'
require 'facilities_management/fm_supplier_data'
RSpec.describe 'select_services/select_services.html.erb', type: :view do
  it 'Counts suppliers for all lot types with a location of UKC1 and a service of C-20' do
    fm_supplier_data = FMSupplierData.new
    supplier_count = fm_supplier_data.long_list_supplier_count("('UKC1')", "('C-20')")
    assert(supplier_count >= 0)
  end

  it 'counts lot1a suppliers with a location of UKC1 and a service of C-20' do
    fm_supplier_data = FMSupplierData.new
    lot1a = fm_supplier_data.long_list_suppliers_lot1a("('UKC1')", "('C-20')")
    assert(!lot1a.nil?)
  end

  it 'counts lot1b suppliers with a location of UKC1 and a service of C-20' do
    fm_supplier_data = FMSupplierData.new
    lot1b = fm_supplier_data.long_list_suppliers_lot1b("('UKC1')", "('C-20')")
    assert(!lot1b.nil?)
  end

  it 'counts lot1c suppliers with a location of UKC1 and a service of C-20' do
    fm_supplier_data = FMSupplierData.new
    lot1c = fm_supplier_data.long_list_suppliers_lot1c("('UKC1')", "('C-20')")
    assert(!lot1c.nil?)
  end
end
