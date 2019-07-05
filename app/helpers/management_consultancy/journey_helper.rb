module ManagementConsultancy::JourneyHelper
  def lot_number_and_description(number, description)
    lot_number = number.split('.')[1]

    "Lot #{lot_number} - #{description}"
  end
end
