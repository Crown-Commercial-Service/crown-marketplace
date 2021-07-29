module FacilitiesManagement
  module RM6232
    class Supplier < ApplicationRecord
      has_many :lot_data, inverse_of: :supplier, class_name: 'FacilitiesManagement::RM6232::Supplier::LotData', dependent: :destroy, foreign_key: :facilities_management_rm6232_supplier_id

      def self.select_suppliers(lot_number, service_codes, region_codes, sector_code)
        joins(:lot_data)
          .where('facilities_management_rm6232_supplier_lot_data.lot_number': lot_number)
          .where('facilities_management_rm6232_supplier_lot_data.service_codes @> ?', "{#{service_codes.join(',')}}")
          .where('facilities_management_rm6232_supplier_lot_data.region_codes @> ?', "{#{region_codes.join(',')}}")
          .where('facilities_management_rm6232_supplier_lot_data.sector_codes @> ?', "{#{sector_code}}")
          .order(:supplier_name)
      end
    end
  end
end
