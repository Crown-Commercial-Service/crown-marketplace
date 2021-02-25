module Pages
  class Procurement < SitePrism::Page
    element :contract_name_field, '#facilities_management_procurement_contract_name'
    element :contract_name, '#main-content > div.govuk-body > div > span'

    element :direct_award_route_to_market, '#facilities_management_procurement_route_to_market_da_draft'
    element :further_competition_route_to_market, '#facilities_management_procurement_route_to_market_further_competition_chosen'
  end
end
