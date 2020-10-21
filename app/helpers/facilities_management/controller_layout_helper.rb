module FacilitiesManagement::ControllerLayoutHelper
  def set_page_detail
    @page_description = LayoutHelper::PageDescription.new(
      LayoutHelper::HeadingDetail.new(*HEADING_DETAIL.map { |detail| page_details(action_name)[detail] }),
      LayoutHelper::BackButtonDetail.new(*BACK_BUTTON_DETAIL.map { |detail| page_details(action_name)[detail] }),
      LayoutHelper::NavigationDetail.new(*NAVIGATION_DETAIL.map { |detail| page_details(action_name)[detail] })
    )
  end

  def set_page_detail_from_view_name
    @page_description = LayoutHelper::PageDescription.new(
      LayoutHelper::HeadingDetail.new(*HEADING_DETAIL.map { |detail| page_details[detail] }),
      LayoutHelper::BackButtonDetail.new(*BACK_BUTTON_DETAIL.map { |detail| page_details[detail] }),
      LayoutHelper::NavigationDetail.new(*NAVIGATION_DETAIL.map { |detail| page_details[detail] })
    )
  end

  HEADING_DETAIL = %i[page_title caption1 caption2 sub_title caption3].freeze
  BACK_BUTTON_DETAIL = %i[back_url back_label back_text].freeze
  NAVIGATION_DETAIL = %i[continuation_text return_url return_text secondary_url secondary_text primary_name secondary_name].freeze

  def page_details(action)
    @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
  end
end
