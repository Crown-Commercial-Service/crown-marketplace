module Pages
  class QuickView < SitePrism::Page
    section :basket, '.basket' do
      elements :selection, 'ul > li > div:nth-of-type(2)'
      element :selection_count, 'h3'
      element :remove_all, 'a[aria-label="Remove all"]'
    end
  end
end
