module FacilitiesManagement::Supplier::SupplierRegionsHelper
  def self.supllier_selected_regions(supplier)
    supplier[0]['regions']&.map { |code| [code, true] }.to_h
  end
end
