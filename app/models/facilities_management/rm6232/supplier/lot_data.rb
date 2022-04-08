module FacilitiesManagement
  module RM6232
    class Supplier::LotData < ApplicationRecord
      belongs_to :supplier, inverse_of: :lot_data, foreign_key: :facilities_management_rm6232_supplier_id

      delegate :supplier_name, to: :supplier

      def services
        Service.where(code: service_codes)
      end

      def regions
        Region.where(code: region_codes)
      end
    end
  end
end
