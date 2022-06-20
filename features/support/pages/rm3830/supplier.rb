module Pages::RM3830
  class ContractNames < SitePrism::Section
    elements :contract_names, 'tbody > tr > td:nth-of-type(1)'
  end

  class Supplier < SitePrism::Page
    section :supplier_tables, '#main-content' do
      section :'Received offers', ContractNames, 'div.govuk-grid-row:nth-child(4) > div:nth-child(1) > table:nth-child(1)'
      section :'Accepted offers', ContractNames, 'div.govuk-grid-row:nth-child(6) > div:nth-child(1) > table:nth-child(1)'
      section :Contracts, ContractNames, 'div.govuk-grid-row:nth-child(8) > div:nth-child(1) > table:nth-child(1)'
      section :Closed, ContractNames, 'div.govuk-grid-row:nth-child(10) > div:nth-child(1) > table:nth-child(1)'

      element :'No received offers', 'div:nth-child(4) > div > span'
      element :'No accepted offers', 'div:nth-child(6) > div > span'
      element :'No contracts', 'div:nth-child(8) > div > span'
      element :'No closed', 'div:nth-child(10) > div > span'
    end

    element :respond_to_contract_yes, '#facilities_management_rm3830_procurement_supplier_contract_response_true'
    element :respond_to_contract_no, '#facilities_management_rm3830_procurement_supplier_contract_response_false'
    element :reason_for_declining, '#facilities_management_rm3830_procurement_supplier_reason_for_declining'
  end
end
