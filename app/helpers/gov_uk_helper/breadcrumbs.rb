module GovUKHelper::Breadcrumbs
  def govuk_breadcrumbs(*breadcrumbs)
    tag.div(class: 'govuk-breadcrumbs') do
      tag.ol(class: 'govuk-breadcrumbs__list') do
        capture do
          breadcrumbs.each { |breadcrumb| concat(govuk_breadcrumb_link(breadcrumb)) }
        end
      end
    end
  end

  def govuk_breadcrumb_link(breadcrumb)
    if breadcrumb[:link].present?
      tag.li(class: 'govuk-breadcrumbs__list-item') do
        link_to breadcrumb[:text], breadcrumb[:link], class: 'govuk-breadcrumbs__link'
      end
    else
      tag.li(class: 'govuk-breadcrumbs__list-item', aria: { current: 'page' }) do
        breadcrumb[:text]
      end
    end
  end
end
