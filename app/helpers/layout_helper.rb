module LayoutHelper
  # Module to render page elements
  # field-sets and input groups
  # errors

  # Classes to structure data for parameters to helper methods
  class BackButtonDetail
    attr_accessor(:url, :text, :label)

    def initialize(back_url, back_label, back_text)
      @url = back_url
      @label = back_label
      @text = back_text
    end
  end

  class HeadingDetail
    attr_accessor(:text, :subtext1, :subtext2)

    def initialize(header_text, sub_heading1, sub_heading2)
      @heading_text = header_text
      @heading_subtext1 = sub_heading1
      @heading_subtext2 = sub_heading2
    end
  end

  class PageDescription
    attr_accessor(:heading_details, :back_button)

    def initialize(heading_details, back_button)
      raise ArgumentError, 'Use a HeadingDetails object' unless heading_details.is_a? HeadingDetail

      raise ArgumentError, 'Use a BackButtonDetail object' unless back_button.is_a? BackButtonDetail

      @heading_details = heading_details
      @back_button = back_button
    end
  end

  # Renders the top of the page including back-button, and the 3 elements of the main header
  def govuk_page_content(page_details, model_object)
    raise ArgumentError, 'Use PageDescription object' unless page_details.is_a? PageDescription

    concat(govuk_page_error_summary(model_object)) unless model_object.nil?
    concat(govuk_back_button(page_details.back_button.url, page_details.back_button.label, page_details.back_button.text))
    concat(govuk_page_header(page_details.heading_details))

    concat yield
  end

  def govuk_page_header(heading_details)
    content_tag(:div, class: 'govuk-clearfix') do
      if heading_details.subtext1.present? || heading_details.subtext2.present?
        concat(content_tag(:span, class: 'govuk-caption-m') do
          concat(heading_details.subtext1)
          concat(" &mdash; #{heading_details.subtext2}") if heading_details.subtext2.present?
        end)
      end
      concat(content_tag(:h1, heading_details.text, class: 'govuk-heading-xl'))
    end
  end

  def govuk_back_button(url, return_to_description=nil, text=nil)
    concat(link_to(text.nil? ? t('layouts.application.back') : text, url, aria: { label: return_to_description.nil? ? t('layouts.application.back_aria_label') : return_to_description }, class: 'govuk-back-link govuk-!-margin-top-0 govuk-!-margin-bottom-6'))
  end

  def govuk_page_error_summary(model_object)
    render partial: 'shared/error_summary', locals: { errors: model_object.errors, render_empty: true }
  end
end
