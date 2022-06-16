module Pages::RM6232
  class Procurement < SitePrism::Page
    element :contract_name_field, '#facilities_management_rm6232_procurement_contract_name'
    element :contract_name, '#main-content > div.govuk-body > div > span'
  end
end
