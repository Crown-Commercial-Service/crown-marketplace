module GovUKHelper::TextInput
  def govuk_text_input(form, attribute, text_input_options)
    class_list = ['govuk-form-group']
    any_errors = form.object.errors.include? attribute
    class_list << 'govuk-form-group--error' if any_errors

    tag.div(class: class_list, id: "#{attribute}-form-group") do
      capture do
        concat(govuk_label(form, attribute, text_input_options[:label])) if text_input_options[:label]
        concat(govuk_hint(text_input_options[:hint])) if text_input_options[:hint]
        concat(govuk_error_message(form, attribute)) if any_errors
        concat(govuk_input(form, attribute, any_errors, text_input_options[:input]))
      end
    end
  end

  private

  def govuk_label(form, attribute, label_options = {})
    class_list = ['govuk-label']
    class_list << label_options[:classes] if label_options[:classes]

    form.label(attribute, label_options[:text], class: class_list, **label_options)
  end

  def govuk_hint(hint_options = {})
    tag.div(hint_options[:text], class: 'govuk-hint', **hint_options)
  end

  def govuk_input(form, attribute, any_errors, input_options = {})
    class_list = ['govuk-input']
    class_list << input_options.delete(:classes) if input_options[:classes]
    class_list << 'govuk-input--error' if any_errors

    prefix = input_options.delete(:prefix)
    suffix = input_options.delete(:suffix)
    text_field = form.text_field(attribute, class: class_list, **input_options[:attributes])

    if prefix || suffix
      tag.div(class: 'govuk-input__wrapper') do
        capture do
          concat(tag.div(prefix[:text], class: 'govuk-input__prefix', aria: { hidden: true })) if prefix
          concat(text_field)
          concat(tag.div(suffix[:text], class: 'govuk-input__suffix', aria: { hidden: true })) if suffix
        end
      end
    else
      text_field
    end
  end
end
