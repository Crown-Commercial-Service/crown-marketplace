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

  def ccs_account_panel_row(**options, &)
    class_list = ['govuk-grid-row govuk-!-margin-bottom-6 fm-buyer-account-panel__container']
    class_list << options.delete(:class)

    tag.div(class: class_list, **options, &)
  end

  def ccs_account_panel(title, title_url, **options, &)
    class_list = ['govuk-grid-column-one-third fm-buyer-account-panel']
    class_list << options.delete(:class)

    tag.div(class: class_list, **options) do
      capture do
        concat(tag.p do
          link_to(title, title_url, class: 'ccs-font-weight-semi-bold fm-buyer-account-panel__title_no_link govuk-!-margin-bottom-2 govuk-link--no-visited-state')
        end)
        concat(tag.p(class: 'govuk-!-top-padding-4', &))
      end
    end
  end
end
