module FacilitiesManagementSuppliersHelper
  def contract_value_range_text(lot_number)
    FacilitiesManagementRegionalAvailability::LOT_NUMBERS[lot_number]
  end
end
