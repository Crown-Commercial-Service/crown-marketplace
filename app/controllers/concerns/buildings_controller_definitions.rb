# rubocop:disable Metrics/ModuleLength
module BuildingsControllerDefinitions
  extend ActiveSupport::Concern
  # rubocop:disable Metrics/AbcSize
  def page_description(action = action_name)
    @page_description ||= LayoutHelper::PageDescription.new(
      LayoutHelper::HeadingDetail.new(building_page_details(action)[:page_title],
                                      building_page_details(action)[:caption1],
                                      building_page_details(action)[:caption2],
                                      building_page_details(action)[:sub_title],
                                      building_page_details(action)[:caption3]),
      LayoutHelper::BackButtonDetail.new(building_page_details(action)[:back_url],
                                         building_page_details(action)[:back_label],
                                         building_page_details(action)[:back_text]),
      LayoutHelper::NavigationDetail.new(building_page_details(action)[:continuation_text],
                                         building_page_details(action)[:return_url],
                                         building_page_details(action)[:return_text],
                                         building_page_details(action)[:secondary_url],
                                         building_page_details(action)[:secondary_text],
                                         building_page_details(action)[:continuation_name],
                                         building_page_details(action)[:secondary_name],
                                         building_page_details(action)[:continuation_url])
    )
  end

  def building_page_details(action)
    @building_page_details ||= if page_definitions.key?(action.to_sym)
                                 page_definitions[:default].merge(page_definitions[action.to_sym])
                               else
                                 page_definitions[:default]
                               end
  end

  # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def page_definitions
    @page_definitions ||= {
      default: {
        continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.create_new_building'),
        continuation_url: new_facilities_management_beta_building_url,
        secondary_name: 'return_to_buildings',
        secondary_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_return_to_detailed_summary'),
        secondary_url: facilities_management_beta_buildings_path,
        back_text: 'Back',
        back_url: facilities_management_beta_buildings_path
      },
      index: {
        page_title: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
        back_url: facilities_management_beta_path
      },
      new: {
        caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
        caption3: step_title,
        page_title: I18n.t('facilities_management.beta.buildings.page_definitions.create_single_building')
      },
      add_address: {
        caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
        caption2: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
        caption3: step_title,
        page_title: I18n.t('facilities_management.beta.buildings.page_definitions.add_building_address'),
        continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_continue'),
        back_url: if id_present?
                    edit_facilities_management_beta_building_path(@page_data[:model_object])
                  else
                    new_facilities_management_beta_building_path
                  end
      },
      edit: {
        caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
        caption2: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
        caption3: step_title,
        page_title: I18n.t('facilities_management.beta.buildings.page_definitions.change_building_details'),
        continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_continue'),
        secondary_name: 'save_and_return',
        secondary_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_return_to_detailed_summary'),
        back_url: (facilities_management_beta_building_path(@page_data[:model_object].id) if id_present?),
      },
      show: {
        continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.return_to_manage_buildings'),
        continuation_url: facilities_management_beta_buildings_url,
        caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
        page_title: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
      },
      gia: {
        caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
        caption2: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
        caption3: step_title,
        page_title: I18n.t('facilities_management.beta.buildings.page_definitions.building_size'),
        continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_continue'),
        secondary_name: 'save_and_return',
        secondary_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_return_to_detailed_summary'),
        return_url: (type_facilities_management_beta_building_path(@page_data[:model_object].id) if id_present?),
        return_text: I18n.t('facilities_management.beta.buildings.page_definitions.skip_this_step'),
        back_url: (edit_facilities_management_beta_building_path(@page_data[:model_object].id) if id_present?),
      },
      type: {
        caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
        caption2: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
        caption3: step_title,
        page_title: I18n.t('facilities_management.beta.buildings.page_definitions.building_type'),
        continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_continue'),
        secondary_name: 'save_and_return',
        secondary_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_return_to_detailed_summary'),
        return_url: (security_facilities_management_beta_building_path(@page_data[:model_object].id) if id_present?),
        return_text: I18n.t('facilities_management.beta.buildings.page_definitions.skip_this_step'),
        back_url: (gia_facilities_management_beta_building_path(@page_data[:model_object].id) if id_present?),
      },
      security: {
        caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
        caption2: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
        caption3: step_title,
        page_title: I18n.t('facilities_management.beta.buildings.page_definitions.security_clearance'),
        continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_return_to_detailed_summary'),
        continuation_name: 'save_and_return',
        secondary_name: 'save_and_return',
        secondary_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_return_to_detailed_summary'),
        return_url: (facilities_management_beta_building_path(@page_data[:model_object].id) if id_present?),
        return_text: I18n.t('facilities_management.beta.buildings.page_definitions.skip_this_step'),
        back_url: (type_facilities_management_beta_building_path(@page_data[:model_object].id) if id_present?)
      }
    }.freeze
  end
  # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def rebuild_page_description(step)
    @building_page_details = @page_description = nil
    build_page_description step
  end

  def build_page_description(step = action_name)
    action = case step
             when 'create'
               'new'
             when 'update'
               'edit'
             else
               step
             end
    page_description action
  end

  # rubocop:enable Metrics/AbcSize
end
# rubocop:enable Metrics/ModuleLength
