require_relative '../quick_view'

module Pages::RM6232
  class SummarySection < SitePrism::Section
    elements :selection, 'details > div > ul > li'
    element :change, 'a'
  end

  class QuickView < Pages::QuickView
    element :annual_contract_value, '#annual_contract_value'

    element :sub_lot, '#procurement-sub-lot'

    section :selection_summary, '#main-content > div:nth-child(2) > div.govuk-grid-column-one-third' do
      section :services, SummarySection, 'div.ccs-summary-box:nth-of-type(1)'
      section :regions, SummarySection, 'div.ccs-summary-box:nth-of-type(2)'

      section :'annual contract cost', 'div.ccs-summary-box:nth-of-type(3)' do
        element :selection, '.ccs-summary-box__content'
        element :change, 'a'
      end
    end

    section :results_container, '#main-content > div:nth-child(2) > div.govuk-grid-column-two-thirds > ul' do
      elements :suppliers, 'li'
    end

    section :service_specification, '#main-content' do
      element :sub_title, 'div.govuk-clearfix > div:nth-child(1) > div > span'
      element :service_name_and_code, 'h2'
    end
  end
end
