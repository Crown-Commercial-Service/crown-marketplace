module ManagementConsultancy
  module SuppliersHelper
    def lot_title(lot)
      "Lot #{lot.number} - #{lot.description}"
    end
  end
end
