module FacilitiesManagement::RM6232
  module ProcurementDetailsHelper
    include FacilitiesManagement::RM6232::ProcurementsHelper

    def edit_page_title
      @edit_page_title ||= t("facilities_management.procurement_details.edit.title.#{section}")
    end

    def show_page_title
      @show_page_title ||= t("facilities_management.procurement_details.show.title.#{section}")
    end
  end
end
