module FacilitiesManagement::RM6232
  module ProcurementDetailsHelper
    include FacilitiesManagement::RM6232::ProcurementsHelper

    def porcurement_services
      @procurement.services_without_lot_consideration.pluck(:name)
    end

    def accordion_service_items
      rm6232_accordion_service_items(@procurement.service_codes)
    end

    def building_name(procurement_building)
      procurement_building.building_name
    end
  end
end
