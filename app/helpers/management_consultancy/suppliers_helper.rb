module ManagementConsultancy::SuppliersHelper
  def mc_lot_key(lot)
    framework = lot.split('.')[0].downcase
    lot_number = lot.split('.')[1]
    "#{framework}.lot_#{lot_number}"
  end
end
