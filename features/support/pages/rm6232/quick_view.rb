module Pages::RM6232
  class QuickView < SitePrism::Page
    element :annual_contract_value, '#annual_contract_value'

    element :sub_lot, '#procurement-sub-lot'

    section :selection_summary, '#main-content > div:nth-child(3) > div.govuk-grid-column-one-third' do
      section :services, 'div.ccs-summary-box:nth-of-type(1)' do
        elements :selection, 'details > div > ul > li'
        element :change, 'a'
      end

      section :regions, 'div.ccs-summary-box:nth-of-type(2)' do
        elements :selection, 'details > div > ul > li'
        element :change, 'a'
      end

      section :'annual contract value', 'div.ccs-summary-box:nth-of-type(3)' do
        element :selection, '.ccs-summary-box__content'
        element :change, 'a'
      end
    end

    section :results_container, '#main-content > div:nth-child(3) > div.govuk-grid-column-two-thirds > ul' do
      elements :suppliers, 'li'
    end
  end
end
