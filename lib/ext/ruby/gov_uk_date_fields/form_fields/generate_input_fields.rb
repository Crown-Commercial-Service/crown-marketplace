module GovUkDateFields
  class FormFields

    private
    def generate_input_fields
      content_tag(:div, class: form_group_classes) do
        content_tag(:fieldset, fieldset_options(@attribute, @options)) do
          concat fieldset_legend(@attribute, @options)
          concat hint(@attribute)
          concat input_fields_div
        end
      end
    end
  end
end