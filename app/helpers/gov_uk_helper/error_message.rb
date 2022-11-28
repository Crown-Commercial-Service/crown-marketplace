module GovUKHelper::ErrorMessage
  def govuk_error_message(form, attribute)
    govuk_error_message_format(attribute, form.object.errors[attribute].first)
  end

  def govuk_error_message_format(attribute, message)
    tag.p(id: "#{attribute}-error", class: 'govuk-error-message') do
      capture do
        concat(tag.span('Error:', class: 'govuk-visually-hidden'))
        concat(message)
      end
    end
  end
end
