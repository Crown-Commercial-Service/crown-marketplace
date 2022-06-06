module FacilitiesManagement::RM6232
  module DetailsHelper
    include FacilitiesManagement::RM6232::ProcurementsHelper

    def page_title
      @page_title ||= t("facilities_management.shared.details.edit.title.#{section}")
    end
  end
end
