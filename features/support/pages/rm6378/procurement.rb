module Pages::RM6378
  class Procurement < SitePrism::Page
    element :view_procurements, '#main-content > div.ccs-dashboard-section > div > div > div > div:nth-child(2) > a'
    element :contract_name_field, '#facilities_management_rm6378_procurement_contract_name'

    section :saved_searches, '#main-content > div.govuk-grid-row > div > div > table' do
      elements :search_names, 'tbody > tr > th'
    end
  end
end
