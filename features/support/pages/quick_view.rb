module Pages
  class QuickView < SitePrism::Page
    section :basket, '#css-list-basket' do
      elements :selection, 'ul > li > div:nth-of-type(2)'
      element :selection_count, 'h3'
      element :remove_all, '#removeAll'
    end
  end
end
