# rubocop:disable Metrics/ModuleLength
module FacilitiesManagement::PageDetail::Buildings
  include FacilitiesManagement::PageDetail

  def page_details(action)
    @page_details ||= if page_definitions.key?(action.to_sym)
                        page_definitions[:default].merge(page_definitions[action.to_sym])
                      else
                        page_definitions[:default]
                      end
  end

  # rubocop:disable Metrics/AbcSize
  def page_definitions
    @page_definitions ||= {
      default: {
        continuation_text: I18n.t('facilities_management.buildings.page_definitions.create_new_building'),
        primary_url: new_facilities_management_building_url,
        secondary_name: 'return_to_buildings',
        secondary_text: I18n.t('facilities_management.buildings.page_definitions.save_and_return_to_detailed_summary'),
        secondary_url: facilities_management_buildings_path(params[:framework]),
        back_text: I18n.t('facilities_management.buildings.page_definitions.return_to_buildings'),
        back_url: facilities_management_buildings_path(params[:framework])
      },
      index: {
        page_title: I18n.t('facilities_management.buildings.page_definitions.manage_building_title'),
        back_url: facilities_management_index_path
      },
      new: {
        back_text: I18n.t('facilities_management.buildings.page_definitions.return_to_buildings'),
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
        caption1: I18n.t('facilities_management.buildings.page_definitions.manage_building_title'),
        page_title: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
        back_text: I18n.t('facilities_management.buildings.page_definitions.return_to_buildings')
      }
    }.freeze
  end
  # rubocop:enable Metrics/AbcSize

  private

  def build_page_description(step = action_name)
    action = case step
             when 'create'
               'new'
             when 'update'
               'edit'
             else
               step
             end
    initialize_page_description action
  end

  def rebuild_page_description(step)
    @building_page_details = @page_description = @page_details = nil
    initialize_page_description step
  end

  def add_address_back_link
    if action_name == 'index' || @page_data[:model_object].id.nil?
      'javascript:history.back()'
    else
      edit_facilities_management_building_path(params[:framework], @page_data[:model_object].id, step: 'building_details')
    end
  end

  # rubocop:disable Metrics/AbcSize
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
      back_url: facilities_management_building_path(params[:framework], @page_data[:model_object], step: 'building_details'),
      back_text: edit_back_text
    }

    details[:continuation_text] = I18n.t('facilities_management.buildings.page_definitions.save_and_return_to_detailed_summary') if params[:step] == 'security'

    if %w[gia type security].include? params[:step]
      details[:return_url] = next_link(false, params[:step])
      details[:return_text] = I18n.t('facilities_management.buildings.page_definitions.skip_this_step')
      details[:back_url] = edit_facilities_management_building_path(params[:framework], @page_data[:model_object].id, step: previous_step(params[:step].to_sym))
    end

    details
  end
  # rubocop:enable Metrics/AbcSize

  def edit_back_text
    case params[:step]
    when 'gia'
      I18n.t('facilities_management.buildings.page_definitions.return_to_building_details')
    when 'type'
      I18n.t('facilities_management.buildings.page_definitions.return_to_building_size')
    when 'security'
      I18n.t('facilities_management.buildings.page_definitions.return_to_building_type')
    else
      I18n.t('facilities_management.buildings.page_definitions.return_to_building_details_summary')
    end
  end
end
# rubocop:enable Metrics/ModuleLength
