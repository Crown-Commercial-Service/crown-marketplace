module ManagementConsultancy::SuppliersHelper
  def mc_lot_key(lot)
    framework = lot.split('.')[0].downcase
    lot_number = lot.split('.')[1]
    "#{framework}.lot_#{lot_number}"
  end

  def framework_lot_and_description(number, description)
    framework = number.split('.')[0].gsub('1', '')
    lot_number = number.split('.')[1]

    "#{framework} lot #{lot_number} - #{description}"
  end
end
