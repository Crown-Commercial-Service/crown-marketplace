module FacilitiesManagement::PageDetail
  extend ActiveSupport::Concern

  def initialize_page_description(action = action_name)
    @page_description = PageDescription.new(
      Heading.new(*HEADING_DETAIL.map { |detail| page_details(action)[detail] }),
      BackButton.new(*BACK_BUTTON_DETAIL.map { |detail| page_details(action)[detail] }),
      Navigation.new(*NAVIGATION_DETAIL.map { |detail| page_details(action)[detail] })
    )
  end

  def initialize_page_description_from_view_name
    @page_description = PageDescription.new(
      Heading.new(*HEADING_DETAIL.map { |detail| page_details[detail] }),
      BackButton.new(*BACK_BUTTON_DETAIL.map { |detail| page_details[detail] }),
      Navigation.new(*NAVIGATION_DETAIL.map { |detail| page_details[detail] })
    )
  end

  HEADING_DETAIL = %i[page_title caption1 caption2 sub_title caption3].freeze
  BACK_BUTTON_DETAIL = %i[back_url back_label back_text].freeze
  NAVIGATION_DETAIL = %i[continuation_text return_url return_text secondary_url secondary_text primary_name secondary_name primary_url].freeze

  def page_details(action)
    @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
  end

  class Navigation
    attr_accessor(:primary_text, :primary_name, :primary_url, :return_url, :return_text, :secondary_url, :secondary_text, :secondary_name)

    # rubocop:disable Metrics/ParameterLists
    def initialize(primary_text, return_url, return_text, secondary_url, secondary_text, primary_name = nil, secondary_name = nil, primary_url = nil)
      @primary_text   = primary_text
      @primary_name   = primary_name
      @primary_url = primary_url
      @return_url     = return_url
      @return_text    = return_text
      @secondary_url  = secondary_url
      @secondary_text = secondary_text
      @secondary_name = secondary_name
    end
    # rubocop:enable Metrics/ParameterLists
  end

  class BackButton
    attr_accessor(:url, :text, :label)

    def initialize(back_url, back_label, back_text)
      @url   = back_url
      @label = back_label
      @text  = back_text
    end
  end

  class Heading
    attr_accessor(:text, :caption, :caption2, :subtitle, :caption3)

    def initialize(header_text, caption1, caption2, sub_text, caption3)
      @text     = header_text
      @caption  = caption1
      @caption2 = caption2
      @subtitle = sub_text
      @caption3 = caption3
    end

    def caption?
      @caption.present? || caption2.present? || caption3.present?
    end
  end

  class PageDescription
    attr_accessor :heading_details, :back_button, :navigation_details, :no_back_button, :no_error_block, :no_headings

    def initialize(heading_details, back_button = nil, continuation = nil)
      raise ArgumentError, 'Use a HeadingDetails object' unless heading_details.is_a? Heading

      raise ArgumentError, 'Use a BackButtonDetail object' unless back_button.nil? || back_button.is_a?(BackButton)

      raise ArgumentError, 'Use a NavigationDetail object' unless continuation.nil? || continuation.is_a?(Navigation)

      @no_back_button     = @no_error_block = @no_headings = false
      @heading_details    = heading_details
      @back_button        = back_button
      @navigation_details = continuation
    end
  end
end
