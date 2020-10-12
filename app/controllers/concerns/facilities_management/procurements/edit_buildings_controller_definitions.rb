module FacilitiesManagement
  module Procurements::EditBuildingsControllerDefinitions
    extend ActiveSupport::Concern
    include Buildings::BuildingsControllerDefinitions

    # rubocop:disable Metrics/AbcSize
    def page_definitions
      @page_definitions ||= {
        default: {
          continuation_text: I18n.t('facilities_management.buildings.page_definitions.create_new_building'),
          continuation_url: new_facilities_management_procurement_edit_building_path(procurement_id: @procurement),
          secondary_name: 'return_to_buildings',
          secondary_text: I18n.t('facilities_management.buildings.page_definitions.save_and_return_to_detailed_summary'),
          secondary_url: edit_facilities_management_procurement_path(@procurement.id, step: 'buildings'),
          back_text: I18n.t('facilities_management.buildings.page_definitions.return_to_buildings'),
          back_url: edit_facilities_management_procurement_path(@procurement.id, step: 'buildings')
        },
        new: {
          caption1: I18n.t('facilities_management.buildings.page_definitions.manage_building_title'),
          caption3: step_title(:new),
          page_title: I18n.t('facilities_management.buildings.page_definitions.create_single_building'),
          secondary_name: 'save_and_return'
        },
        add_address: {
          caption1: I18n.t('facilities_management.buildings.page_definitions.manage_building_title'),
          caption2: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
          caption3: step_title(:add_address),
          page_title: I18n.t('facilities_management.buildings.page_definitions.add_building_address'),
          continuation_text: I18n.t('facilities_management.buildings.page_definitions.save_and_continue'),
          back_url: add_address_back_link,
          back_text: I18n.t('facilities_management.buildings.page_definitions.return_to_building_details')
        },
        edit: edit_details,
        show: {
          continuation_text: I18n.t('facilities_management.buildings.page_definitions.return_to_manage_buildings'),
          continuation_url: facilities_management_buildings_url,
          caption1: I18n.t('facilities_management.buildings.page_definitions.manage_building_title'),
          page_title: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
        }
      }.freeze
    end

    def add_address_back_link
      if @page_data[:model_object].id.nil?
        'javascript:history.back()'
      else
        edit_facilities_management_procurement_edit_building_path(@page_data[:model_object].id, step: 'building_details')
      end
    end

    def edit_details
      return if params[:step].nil? || @page_data[:model_object].id.nil?

      details = {
        caption1: I18n.t('facilities_management.buildings.page_definitions.manage_building_title'),
        caption2: @page_data[:model_object]&.building_name,
        caption3: step_title(params[:step].to_sym),
        page_title: I18n.t("facilities_management.buildings.page_definitions.#{params[:step]}"),
        continuation_text: I18n.t('facilities_management.buildings.page_definitions.save_and_continue'),
        secondary_name: 'save_and_return',
        secondary_text: I18n.t('facilities_management.buildings.page_definitions.save_and_return_to_detailed_summary'),
        back_url: facilities_management_procurement_edit_building_path(@page_data[:model_object].id, procurement_id: @procurement.id),
        back_text: edit_back_text
      }

      details[:continuation_text] = I18n.t('facilities_management.buildings.page_definitions.save_and_return_to_detailed_summary') if params[:step] == 'security'

      if %w[gia type security].include? params[:step]
        details[:return_url] = next_link(false, params[:step])
        details[:return_text] = I18n.t('facilities_management.buildings.page_definitions.skip_this_step')
        details[:back_url] = edit_facilities_management_procurement_edit_building_path(@page_data[:model_object].id, procurement_id: @procurement.id, step: previous_step(params[:step].to_sym))
      end

      details
    end
    # rubocop:enable Metrics/AbcSize
  end
end
