module FacilitiesManagement::Admin::FrameworkHelper
  def admin_breadcrumbs(*breadcrumbs)
    breadcrumbs.prepend({ text: 'Home', link: facilities_management_rm3830_admin_path })

    govuk_breadcrumbs(*breadcrumbs)
  end

  def account_dashboard_panel(link_text, link_url, description)
    tag.div(class: 'govuk-grid-column-one-third') do
      tag.div(class: 'fm-buyer-account-panel') do
        capture do
          concat(link_to(link_text, link_url, class: 'fm-buyer-account-panel__title'))
          concat(tag.p(description, class: 'fm-buyer-account-panel__body'))
        end
      end
    end
  end
end
