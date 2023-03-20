# rubocop:disable Metrics/ModuleLength
module GovUKHelper::Accordion
  def govuk_accordion(name, sections, &)
    tag.div(class: 'govuk-accordion', id: "accordion-with-summary-sections-for-#{name}", data: { module: 'govuk-accordion' }) do
      capture do
        sections.each.with_index(1) do |section, index|
          concat(tag.div(class: 'govuk-accordion__section') do
            capture do
              concat(govuk_accordion_heading(index, section[:name]))
              concat(govuk_accordion_content(index, name, section, &))
            end
          end)
        end
      end
    end
  end

  def govuk_accordion_with_checkboxes(name, sections, model_name, attribute, &)
    tag.div(class: 'govuk-accordion', id: "accordion-with-summary-sections-for-#{name}", data: { module: 'govuk-accordion' }) do
      capture do
        sections.each.with_index(1) do |(section_id, section), index|
          concat(tag.div(class: 'govuk-accordion__section chooser-section', data: { section: section_id, sectionname: section[:name] }) do
            capture do
              concat(govuk_accordion_heading(index, section[:name]))
              concat(govuk_accordion_content(index, section[:name], section) do
                check_boxes_for_section(section_id, model_name, attribute, section[:name], section[:items], &)
              end)
            end
          end)
        end
      end
    end
  end

  private

  def govuk_accordion_heading(index, heading_text)
    tag.div(class: 'govuk-accordion__section-header') do
      tag.h2(class: 'govuk-accordion__section-heading') do
        tag.span(heading_text, class: 'govuk-accordion__section-button', id: govuk_accordion_heading_id(index))
      end
    end
  end

  def govuk_accordion_content(index, name, section, &block)
    tag.div(class: 'govuk-accordion__section-content', id: govuk_accordion_content_id(name, index), aria: { labelledby: govuk_accordion_heading_id(index) }) do
      yield(section) if block
    end
  end

  def check_boxes_for_section(section_id, model_name, attribute, section_name, items, &)
    tag.div(class: 'govuk-form-group chooser-input', sectionname: section_name, section: section_id) do
      tag.div(class: 'govuk-checkboxes') do
        capture do
          items.each do |item|
            concat(tag.div(class: 'govuk-checkboxes__item') do
              capture do
                concat(check_box_item(section_id, model_name, attribute, item))
                concat(check_box_label(section_id, model_name, item, &))
              end
            end)
          end
          if items.length > 1
            concat(tag.p('Or', class: 'govuk-body govuk-!-margin-top-4'))
            concat(select_all_checkbox(section_id, model_name))
          end
        end
      end
    end
  end

  def check_box_item(section_id, model_name, attribute, item)
    check_box_tag(
      "#{attribute}[]",
      item[:value],
      item[:selected],
      title: item[:name],
      class: 'govuk-checkboxes__input',
      sectionid: section_id,
      id: "#{model_name}_#{item[:code]}"
    )
  end

  def check_box_label(section_id, model_name, item, &block)
    tag.label(class: 'govuk-label govuk-checkboxes__label', for: "#{model_name}_#{item[:code]}") do
      capture do
        concat(item[:name])
        concat(tag.div(item[:description], class: 'govuk-hint')) if item[:description]
        concat(tag.div(yield(section_id, item))) if block
      end
    end
  end

  def select_all_checkbox(section_id, model_name)
    tag.div(class: 'govuk-checkboxes__item ccs-select-all') do
      capture do
        concat(tag.input(
                 class: 'govuk-checkboxes__input',
                 id: "#{model_name}_#{section_id}_all",
                 name: 'section-checkbox_select_all',
                 type: 'checkbox',
                 value: ''
               ))
        concat(check_box_label(section_id, model_name, { name: 'Select all', code: "#{section_id}_all" }))
      end
    end
  end

  def govuk_accordion_heading_id(index)
    "accordion-with-summary-sections-heading-#{index + 1}"
  end

  def govuk_accordion_content_id(name, index)
    "accordion-with-summary-sections-for-#{name}-content-#{index + 1}"
  end
end
# rubocop:enable Metrics/ModuleLength
