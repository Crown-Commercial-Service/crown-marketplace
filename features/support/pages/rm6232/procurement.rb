module Pages::RM6232
  class ProcurementSummarySection < SitePrism::Section
    element :number, '.govuk-details__summary'
    elements :names, 'li'
  end

  class Procurement < SitePrism::Page
    element :contract_name_field, '#facilities_management_rm6232_procurement_contract_name'
    element :contract_name, '#main-content > div.govuk-body > div > span'

    element :sub_lot, '#main-content > div:nth-child(4) > div > h2'

    element :number_of_suppliers, '#main-content > div:nth-child(4) > div > h3'

    section :buildings, ProcurementSummarySection, '#main-content > div:nth-child(6) > div > div.govuk-\!-margin-bottom-4 > details'
    section :services, ProcurementSummarySection, '#main-content > div:nth-child(6) > div > div.govuk-\!-margin-bottom-6 > details'
  end
end
