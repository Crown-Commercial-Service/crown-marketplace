module FacilitiesManagementSuppliersHelper
  def contract_value_range_text(lot_number)
    FacilitiesManagementLot.find_by(number: lot_number).description
  end
end
