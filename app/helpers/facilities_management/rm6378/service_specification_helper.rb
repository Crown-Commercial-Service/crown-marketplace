module FacilitiesManagement::RM6378
  module ServiceSpecificationHelper
    def work_package_name(category)
      t("facilities_management.rm6378.journey.choose_services.services.section.#{category}.title")
    end
  end
end
