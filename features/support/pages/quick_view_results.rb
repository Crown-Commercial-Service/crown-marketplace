module Pages
  class QuickViewResults < SitePrism::Page
    element :quick_search_contract_name, 'form > div > div:nth-child(1) > div > span'

    section :basket, '.basket' do
      elements :selection, 'ul > li > div:nth-of-type(2)'
      element :selection_count, 'h3'
      element :remove_all, 'a[aria-label="Remove all"]'
    end

    section :requirements_list, '#requirements-list' do
      section :services, 'div > div > div[data-section="service"]' do
        element :summary, 'details > summary > span'
        elements :details, 'li'
      end

      section :regions, 'div > div > div[data-section="region"]' do
        element :summary, 'details > summary > span'
        elements :details, 'li'
      end
    end
  end
end
