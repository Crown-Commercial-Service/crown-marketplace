module FacilitiesManagement::RM3830::Supplier::SupplierRegionsHelper
  def self.supllier_selected_regions(supplier_region_data)
    supplier_region_data&.index_with { |_code| true }
  end
end
