module FacilitiesManagement::Admin::FrameworkHelper
  def admin_breadcrumbs(*breadcrumbs)
    breadcrumbs.prepend({ text: 'Home', href: facilities_management_admin_index_path })

    content_for :breadcrumbs do
      govuk_breadcrumbs(breadcrumbs)
    end
  end

  def framework_expired_warning(text)
    govuk_warning_text(text) if @framework_has_expired
  end
end
