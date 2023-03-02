module CrownMarketplace::FrameworkHelper
  def crown_marketplace_breadcrumbs(*breadcrumbs)
    breadcrumbs.prepend({ text: 'Home', href: crown_marketplace_path })

    govuk_breadcrumbs(breadcrumbs)
  end
end
