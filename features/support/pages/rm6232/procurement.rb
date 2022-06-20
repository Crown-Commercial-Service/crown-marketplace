module Pages::RM6232
  class Procurement < SitePrism::Page
    element :contract_name_field, '#facilities_management_rm6232_procurement_contract_name'
    element :contract_name, '#main-content > div.govuk-body > div > span'

    element :sub_lot, '#main-content > div:nth-child(4) > div > h2'

    element :number_of_suppliers, '#main-content > div:nth-child(4) > div > h3'

    section :buildings, '#main-content > div:nth-child(6) > div > div.govuk-\!-margin-bottom-4 > details' do
      element :number_of_buildings, '.govuk-details__summary'
      elements :building_names, 'li'
    end

    section :services, '#main-content > div:nth-child(6) > div > div.govuk-\!-margin-bottom-6 > details' do
      element :number_of_services, '.govuk-details__summary'
      elements :service_names, 'li'
    end
  end
end
