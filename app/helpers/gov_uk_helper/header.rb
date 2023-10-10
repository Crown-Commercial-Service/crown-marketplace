module GovUKHelper::Header
  def govuk_header(service, navigation_links = [])
    tag.header(class: 'govuk-header', role: 'banner', data: { module: 'govuk-header' }) do
      tag.div(class: 'govuk-header__container govuk-width-container') do
        capture do
          concat(govuk_header_logo)
          concat(govuk_header_content(service, navigation_links))
        end
      end
    end
  end

  def govuk_header_logo
    tag.div(class: 'govuk-header__logo') do
      link_to(ccs_homepage_url, class: 'govuk-header__link govuk-header__link--homepage') do
        tag.span(class: 'govuk-header__logotype') do
          capture do
            concat(render(partial: '/layouts/logotype'))
            concat(tag.span(t('layouts.logotype.ccs_logo_title'), class: 'govuk-header__logotype-text ccs-remove'))
          end
        end
      end
    end
  end

  def govuk_header_content(service, navigation_links)
    tag.div(class: 'govuk-header__content') do
      capture do
        concat(tag.div(service, class: 'govuk-header__link govuk-header__link--service-name ccs-header__service-name'))
        concat(tag.nav(class: 'govuk-header__navigation', aria: { label: 'Menu' }) do
          capture do
            concat(tag.button('Menu', type: 'button', class: 'govuk-header__menu-button govuk-js-header-toggle', aria: { controls: 'navigation', label: 'Show or hide menu' }, hidden: ''))
            concat(tag.ul(id: 'navigation', class: 'govuk-header__navigation-list') do
              capture do
                navigation_links.each do |navigation_link|
                  concat(
                    govuk_header_navigation_item(
                      navigation_link[:link_text],
                      navigation_link[:link_url],
                      **(navigation_link[:options] || {})
                    )
                  )
                end
              end
            end)
          end
        end)
      end
    end
  end

  def govuk_header_navigation_item(link_text, link_url, **)
    tag.li(class: 'govuk-header__navigation-item') do
      link_to(link_text, link_url, class: 'govuk-header__link', **)
    end
  end
end
