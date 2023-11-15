module Pages
  class Home < SitePrism::Page
    section :navigation, '#navigation' do
      elements :links, 'a'
    end
  end
end
