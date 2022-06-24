require_relative '../quick_view'

module Pages::RM3830
  class SummarySection < SitePrism::Section
    element :summary, 'details > summary > span'
    elements :details, 'li'
  end

  class SuppliersList < SitePrism::Section
    elements :suppliers, 'tr'
  end

  class QuickView < Pages::QuickView
    element :quick_search_contract_name, 'form > div > div:nth-child(1) > div > span'

    section :requirements_list, '#requirements-list' do
      section :services, SummarySection, 'div > div > div[data-section="service"]'
      section :regions, SummarySection, 'div > div > div[data-section="region"]'
    end

    section :results_container, '#supplier-lot-list__container' do
      section :'1a', SuppliersList, 'div > div:nth-child(1) > table > tbody'
      section :'1b', SuppliersList, 'div > div:nth-child(2) > table > tbody'
      section :'1c', SuppliersList, 'div > div:nth-child(3) > table > tbody'
    end
  end
end
