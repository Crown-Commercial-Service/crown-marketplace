module GovUKHelper::Select
  def govuk_select(form, attribute, select_options)
    class_list = ['govuk-form-group']
    any_errors = form.object.errors.include? attribute
    class_list << 'govuk-form-group--error' if any_errors

    tag.div(class: class_list, id: "#{attribute}-form-group") do
      capture do
        concat(govuk_label(form, attribute, select_options[:label])) if select_options[:label]
        concat(govuk_hint(select_options[:hint])) if select_options[:hint]
        concat(govuk_error_message(form, attribute)) if any_errors
        concat(govuk_select_input(attribute, any_errors, select_options[:select]))
      end
    end
  end

  private

  def govuk_select_input(attribute, any_errors, select_options)
    class_list = ['govuk-select']
    class_list << select_options.delete(:classes) if select_options[:classes]
    class_list << 'govuk-select--error' if any_errors

    options = select_options[:options].map do |select_option|
      [select_option[:text] || select_option[:value], select_option[:value], select_option[:attributes]]
    end

    select_tag(attribute, options_for_select(options, select_options[:selected]), class: class_list, prompt: select_options[:prompt], **(select_options[:attributes] || {}))
  end
end
