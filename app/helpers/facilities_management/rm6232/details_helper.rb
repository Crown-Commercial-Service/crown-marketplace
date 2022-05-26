module FacilitiesManagement::RM6232
  module DetailsHelper
    include FacilitiesManagement::RM6232::ProcurementsHelper
    include FacilitiesManagement::DetailsHelper

    def edit_page_title
      @edit_page_title ||= t("facilities_management.shared.details.edit.title.#{section}")
    end

    def show_page_title
      @show_page_title ||= t("facilities_management.shared.details.show.title.#{section}")
    end
  end
end
