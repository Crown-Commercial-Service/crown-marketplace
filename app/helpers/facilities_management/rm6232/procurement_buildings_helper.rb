module FacilitiesManagement::RM6232
  module ProcurementBuildingsHelper
    include FacilitiesManagement::RM6232::ProcurementsHelper

    def procurement_services
      @procurement.services_without_lot_consideration
    end
  end
end
