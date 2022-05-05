module FacilitiesManagement::Admin::FrameworkHelper
  def admin_breadcrumbs(*breadcrumbs)
    breadcrumbs.prepend({ text: 'Home', link: facilities_management_admin_index_path })

    govuk_breadcrumbs(*breadcrumbs)
  end
end
