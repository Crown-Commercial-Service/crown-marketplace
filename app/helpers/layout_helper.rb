module LayoutHelper
  def form_group_with_error(model, attribute)
    css_classes = ['govuk-form-group']
    any_errors = model.errors.include? attribute
    css_classes += ['govuk-form-group--error'] if any_errors

    tag.div(class: css_classes, id: "#{attribute}-form-group") do
      yield(display_error(model, attribute), any_errors)
    end
  end

  # looks up the locals data for validation messages
  def validation_messages(model_object_sym, attribute_sym = nil)
    translation_key = "activerecord.errors.models.#{model_object_sym.downcase}.attributes"
    translation_key += if attribute_sym.is_a? Array
                         ".#{attribute_sym.join('.')}"
                       else
                         ".#{attribute_sym}"
                       end

    result = t(translation_key)
    if result.include? 'translation_missing'
      translation_key.sub! 'activerecord', 'activemodel'
      result = t(translation_key)
    end

    return {} if result.include? 'translation_missing'

    result
  end
end
