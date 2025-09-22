module CrownMarketplace::FrameworkHelper
  def crown_marketplace_breadcrumbs(*breadcrumbs)
    breadcrumbs.prepend({ text: 'Home', href: crown_marketplace_path })

    content_for :breadcrumbs do
      govuk_breadcrumbs(breadcrumbs)
    end
  end
end
