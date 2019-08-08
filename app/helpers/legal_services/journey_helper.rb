module LegalServices::JourneyHelper
  def lot_full_description(lot)
    "Lot #{lot.number} - #{lot.description}"
  end

  def lot_legal_services(lot)
    "Lot #{lot.number} legal services"
  end

  def region_name(name)
    name.split('(')[0].strip
  end
end
