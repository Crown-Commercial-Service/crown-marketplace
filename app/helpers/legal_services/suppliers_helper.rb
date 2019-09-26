module LegalServices::SuppliersHelper
  def full_lot_description(lot_number, description)
    "Lot #{lot_number} - #{description}"
  end
end
