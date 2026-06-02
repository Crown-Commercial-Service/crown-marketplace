module FacilitiesManagement
  module RM6378
    class Supplier < ApplicationRecord

      self.table_name = 'facilities_management_rm6378_suppliers'
      
      has_many :lot_data, inverse_of: :supplier, class_name: 'FacilitiesManagement::RM6378::Supplier::LotData', dependent: :destroy, foreign_key: :facilities_management_rm6378_supplier_id

      def self.select_suppliers(lot_code, service_codes, region_codes)
        where(active: true)
          .joins(:lot_data)
          .where('facilities_management_rm6378_supplier_lot_data.active': true)
          .where('facilities_management_rm6378_supplier_lot_data.lot_code': lot_code)
          .where('facilities_management_rm6378_supplier_lot_data.service_codes @> ?', "{#{service_codes.join(',')}}")
          .where('facilities_management_rm6378_supplier_lot_data.region_codes @> ?', "{#{region_codes.join(',')}}")
          .order(:supplier_name)
      end
    end
  end
end
