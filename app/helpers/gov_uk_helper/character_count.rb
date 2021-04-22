module GovUKHelper::CharacterCount
  def govuk_character_count(form, attribute, max_length, rows, **options)
    @form = form
    @attribute = attribute
    @max_length = max_length
    @rows = rows
    @options = options

    tag.div(class: 'govuk-character-count', data: { module: 'govuk-character-count', maxlength: @max_length }) do
      capture do
        concat(govuk_text_area)
        concat(govuk_characters_remaing)
      end
    end
  end

  def govuk_text_area
    class_list = 'govuk-textarea govuk-js-character-count'
    class_list << ' govuk-textarea--error' if @form.object.errors.include? @attribute

    @form.text_area @attribute, class: class_list, rows: @rows, **@options
  end

  def govuk_characters_remaing
    tag.div("You have #{@max_length} characters remaining", id: "#{@form.object_name}_#{@attribute}-info", class: 'govuk-hint govuk-character-count__message', aria: { live: 'polite' })
  end
end
