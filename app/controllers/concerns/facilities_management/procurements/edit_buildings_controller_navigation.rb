module FacilitiesManagement
  module Procurements::EditBuildingsControllerNavigation
    extend ActiveSupport::Concern
    include Buildings::BuildingsControllerNavigation

    def next_link(save_and_return, step)
      if save_and_return || step == 'security'
        facilities_management_procurement_edit_building_path(id: @page_data[:model_object].id, procurement_id: @procurement.id)
      else
        edit_facilities_management_procurement_edit_building_path(id: @page_data[:model_object].id, procurement_id: @procurement.id, step: next_step(step.to_sym).to_s)
      end
    end
  end
end
