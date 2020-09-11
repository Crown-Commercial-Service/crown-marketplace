# rubocop:disable Metrics/ModuleLength
module Buildings::BuildingsControllerDefinitions
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

  def page_definitions
    @page_definitions ||= {
      default: {
        continuation_text: I18n.t('facilities_management.buildings.page_definitions.create_new_building'),
        continuation_url: new_facilities_management_building_url,
        secondary_name: 'return_to_buildings',
        secondary_text: I18n.t('facilities_management.buildings.page_definitions.save_and_return_to_detailed_summary'),
        secondary_url: facilities_management_buildings_path,
        back_text: I18n.t('facilities_management.buildings.page_definitions.return_to_buildings'),
        back_url: facilities_management_buildings_path
      },
      index: {
        page_title: I18n.t('facilities_management.buildings.page_definitions.manage_building_title'),
        back_url: facilities_management_path
      },
      new: {
        back_text: I18n.t('facilities_management.buildings.page_definitions.return_to_manage_buildings'),
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
        back_text: I18n.t('facilities_management.buildings.page_definitions.return_to_building_details'),
        back_url: add_address_back_link
      },
      edit: edit_details,
      show: {
        continuation_text: I18n.t('facilities_management.buildings.page_definitions.return_to_manage_buildings'),
        continuation_url: facilities_management_buildings_url,
        caption1: I18n.t('facilities_management.buildings.page_definitions.manage_building_title'),
        page_title: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
        back_text: I18n.t('facilities_management.buildings.page_definitions.return_to_manage_buildings')
      }
    }.freeze
  end
  # rubocop:enable

  def add_address_back_link
    if action_name == 'index' || @page_data[:model_object].id.nil?
      'javascript:history.back()'
    else
      edit_facilities_management_building_path(@page_data[:model_object].id, step: 'building_details')
    end
  end

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

  # rubocop:disable Metrics/CyclomaticComplexity
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
      back_url: facilities_management_building_path(@page_data[:model_object], step: 'building_details'),
      back_text: I18n.t('facilities_management.buildings.page_definitions.return_to_building_details')
    }

    details[:back_text] = I18n.t('facilities_management.buildings.page_definitions.return_to_building_details_summary') if params[:step] == 'building_details'

    if %w[gia type security].include? params[:step]
      details[:return_url] = next_link(false, params[:step])
      details[:return_text] = I18n.t('facilities_management.buildings.page_definitions.skip_this_step')
      details[:back_url] = edit_facilities_management_building_path(@page_data[:model_object].id, step: previous_step(params[:step].to_sym))
    end

    details[:back_text] = I18n.t('facilities_management.buildings.page_definitions.return_to_building_size') if params[:step] == 'type'

    if params[:step] == 'security'
      details[:back_text] = I18n.t('facilities_management.buildings.page_definitions.return_to_building_type')
      details[:continuation_text] = I18n.t('facilities_management.buildings.page_definitions.save_and_return_to_detailed_summary')
    end

    details
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def building_details
    {
      building_name: { row_name: t('facilities_management.buildings.action_partials.show.caption_name'), row_text: @page_data[:model_object].building_name, step: 'building_details' },
      building_description: { row_name: t('facilities_management.buildings.action_partials.show.caption_desc'), row_text: @page_data[:model_object].description, step: 'building_details' },
      address: { row_name: t('facilities_management.buildings.action_partials.show.caption_addr'), row_text: @page_data[:model_object].address_line_1, step: 'building_details' },
      region: { row_name: t('facilities_management.buildings.action_partials.show.caption_region_nuts'), row_text: @page_data[:model_object].address_region, step: 'building_details' },
      gia: { row_name: t('facilities_management.buildings.action_partials.show.caption_gia'), row_text: @page_data[:model_object].gia, step: 'gia' },
      external_area: { row_name: t('facilities_management.buildings.action_partials.show.caption_external_area'), row_text: @page_data[:model_object].external_area, step: 'gia' },
      building_type: { row_name: t('facilities_management.buildings.action_partials.show.caption_type'), row_text: @page_data[:model_object].building_type, step: 'type' },
      security_type: { row_name: t('facilities_management.buildings.action_partials.show.caption_sec'), row_text: @page_data[:model_object].security_type, step: 'security' }
    }
  end
  # rubocop:enable Metrics/AbcSize
end
# rubocop:enable Metrics/ModuleLength
