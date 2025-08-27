module Pages
  class Home < SitePrism::Page
    section :navigation, '#navigation' do
      elements :links, 'a'
      elements :buttons, 'button'
    end
  end
end
