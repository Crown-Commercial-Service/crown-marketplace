module FacilitiesManagement
  module RM6232
    class Procurement < ApplicationRecord
      include AASM

      belongs_to :user, inverse_of: :rm6232_procurements

      def quick_view_suppliers
        @quick_view_suppliers ||= SuppliersSelector.new(service_codes, region_codes, sector_code, estimated_contract_cost)
      end

      def services
        @services ||= Service.where(code: service_codes).order(:work_package_code, :sort_order)
      end

      def regions
        @regions ||= Region.where(code: region_codes)
      end

      def sector
        Sector.find(sector_code)
      end
    end
  end
end
