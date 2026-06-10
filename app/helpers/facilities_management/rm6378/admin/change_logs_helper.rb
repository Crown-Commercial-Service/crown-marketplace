module FacilitiesManagement::RM6378::Admin::ChangeLogsHelper
  include Admin::ChangeLogsHelper

  def update_supplier_framework_lot_item_list(item_ids, model, &)
    translation_string = if model == Service
                           'facilities_management.rm6378.journey.choose_services.services.section.%s.title'
                         elsif model == Jurisdiction
                           'facilities_management.rm6378.journey.choose_locations.regions.section.%s.title'
                         end

    super do |group, items|
      yield(I18n.t(translation_string % group), items)
    end
  end
end
