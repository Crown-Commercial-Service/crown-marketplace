module FacilitiesManagement::Supplier::SupplierRegionsHelper
  def self.supllier_selected_regions(supplier_region_data)
    supplier_region_data&.map { |code| [code, true] }.to_h
  end
end
