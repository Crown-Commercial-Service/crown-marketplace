module FacilitiesManagement::ControllerLayoutHelper
  # rubocop:disable Metrics/AbcSize
  def set_page_detail
    @page_description = LayoutHelper::PageDescription.new(
      LayoutHelper::HeadingDetail.new(page_details(action_name)[:page_title],
                                      page_details(action_name)[:caption1],
                                      page_details(action_name)[:caption2],
                                      page_details(action_name)[:sub_title],
                                      page_details(action_name)[:caption3]),
      LayoutHelper::BackButtonDetail.new(page_details(action_name)[:back_url],
                                         page_details(action_name)[:back_label],
                                         page_details(action_name)[:back_text]),
      LayoutHelper::NavigationDetail.new(page_details(action_name)[:continuation_text],
                                         page_details(action_name)[:return_url],
                                         page_details(action_name)[:return_text],
                                         page_details(action_name)[:secondary_url],
                                         page_details(action_name)[:secondary_text])
    )
  end

  def page_details(action)
    @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
  end
  # rubocop:enable Metrics/AbcSize
end
