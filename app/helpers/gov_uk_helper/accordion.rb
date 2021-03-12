module GovUKHelper::Accordion
  def govuk_accordion(title, &block)
    @title = title
    tag.div(class: 'govuk-accordion', id: "accordion-with-summary-sections-for-#{title}", data: { module: 'govuk-accordion' }, &block)
  end

  def govuk_accordion_add_section(index, heading_text, **options, &block)
    class_list = ['govuk-accordion__section']
    class_list << options.delete(:class)

    tag.div(class: class_list.compact.join(' '), **options) do
      capture do
        concat(govuk_accordion_heading(index, heading_text))
        concat(govuk_accordion_content(index, &block))
      end
    end
  end

  def govuk_accordion_heading(index, heading_text)
    tag.div(class: 'govuk-accordion__section-header') do
      tag.h2(class: 'govuk-accordion__section-heading') do
        tag.span(heading_text, class: 'govuk-accordion__section-button', id: govuk_accordion_heading_id(index))
      end
    end
  end

  def govuk_accordion_content(index, &block)
    tag.div(class: 'govuk-accordion__section-content', id: govuk_accordion_content_id(index), aria: { labelledby: govuk_accordion_heading_id(index) }, &block)
  end

  def govuk_accordion_heading_id(index)
    "accordion-with-summary-sections-heading-#{index + 1}"
  end

  def govuk_accordion_content_id(index)
    "accordion-with-summary-sections-for-#{@title}-content-#{index + 1}"
  end
end
