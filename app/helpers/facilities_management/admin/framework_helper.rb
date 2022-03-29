module FacilitiesManagement::Admin::FrameworkHelper
  def admin_breadcrumbs(*breadcrumbs)
    breadcrumbs.prepend({ text: 'Home', link: facilities_management_rm3830_admin_path })

    govuk_breadcrumbs(*breadcrumbs)
  end
end
