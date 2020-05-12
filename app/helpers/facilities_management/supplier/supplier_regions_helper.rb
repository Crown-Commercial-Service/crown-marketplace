module FacilitiesManagement::Supplier::SupplierRegionsHelper
  def self.supllier_selected_regions(supplier)
    supplier_checked_regions = {}
    supplier[0]['regions']&.each { |code| supplier_checked_regions[code] = true }
    supplier_checked_regions
  end
end
