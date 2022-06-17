require_relative '../quick_view'

module Pages::RM3830
  class QuickView < Pages::QuickView
    element :quick_search_contract_name, 'form > div > div:nth-child(1) > div > span'

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

    section :results_container, '#supplier-lot-list__container' do
      section :'1a', 'div > div:nth-child(1) > table > tbody' do
        elements :suppliers, 'tr'
      end

      section :'1b', 'div > div:nth-child(2) > table > tbody' do
        elements :suppliers, 'tr'
      end

      section :'1c', 'div > div:nth-child(3) > table > tbody' do
        elements :suppliers, 'tr'
      end
    end
  end
end
