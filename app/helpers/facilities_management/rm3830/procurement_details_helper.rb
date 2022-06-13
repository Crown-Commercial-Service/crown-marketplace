module FacilitiesManagement::RM3830
  module ProcurementDetailsHelper
    def page_subtitle
      @procurement.contract_name
    end

    def porcurement_services
      @procurement.services.pluck(:name)
    end

    def accordion_service_items
      rm3830_accordion_service_items(@procurement.service_codes)
    end

    def building_name(procurement_building)
      procurement_building.name
    end
  end
end
