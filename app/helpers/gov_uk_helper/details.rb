module GovUKHelper::Details
  def govuk_details(summary_text, **options, &)
    govuk_details_class = ['govuk-details']
    govuk_details_class << options.delete(:class) if options[:class]

    tag.details(class: govuk_details_class, data: { module: 'govuk-details' }, **options) do
      capture do
        concat(tag.summary(tag.span(summary_text, class: 'govuk-details__summary-text'), class: 'govuk-details__summary'))
        concat(tag.div(class: 'govuk-details__text', &))
      end
    end
  end
end
