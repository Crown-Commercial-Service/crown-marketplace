module GovUKHelper::Radios
  def govuk_radios_conditional(&)
    tag.div(class: 'govuk-radios govuk-radios--conditional', data: { module: 'govuk-radios' }, &)
  end

  def govuk_radios_conditional_item(form, attribute, value, label_text)
    tag.div(class: 'govuk-radios__item') do
      capture do
        concat(form.radio_button(attribute, value, value: value, class: 'govuk-radios__input', data: { 'aria-controls': govuk_radios_conditional_id(attribute, value) }))
        concat(form.label(attribute, label_text, value: value, class: 'govuk-label govuk-radios__label'))
        yield if block_given?
      end
    end
  end

  def govuk_radios_conditional_area(attribute, value, **options, &)
    class_list = ['govuk-radios__conditional govuk-radios__conditional--hidden']
    class_list << options.delete(:class)

    tag.div(class: class_list.compact.join(' '), id: govuk_radios_conditional_id(attribute, value), **options, &)
  end

  def govuk_radios_conditional_id(attribute, value)
    "#{attribute}-#{value}"
  end
end
