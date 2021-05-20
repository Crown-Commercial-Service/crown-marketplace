module Pages
  class DirectAward < SitePrism::Page
    element :supplier_name, 'form > table:nth-of-type(1) > tbody > tr:nth-child(2) > td'

    section :supplier_contact_details, 'form > div > div > table' do
      element :supplier_name, 'tbody > tr:nth-child(2) > th'
      element :details, '#contact-details-drop-down > details > div'
    end

    section :supplier_tables, '#main-content' do
      section :'Received offers', 'div.govuk-grid-row:nth-child(4) > div:nth-child(1) > table:nth-child(1)' do
        elements :contract_names, 'tbody > tr > td:nth-of-type(1)'
      end

      section :'Accepted offers', 'div.govuk-grid-row:nth-child(6) > div:nth-child(1) > table:nth-child(1)' do
        elements :contract_names, 'tbody > tr > td:nth-of-type(1)'
      end

      section :Contracts, 'div.govuk-grid-row:nth-child(8) > div:nth-child(1) > table:nth-child(1)' do
        elements :contract_names, 'tbody > tr > td:nth-of-type(1)'
      end

      section :Closed, 'div.govuk-grid-row:nth-child(10) > div:nth-child(1) > table:nth-child(1)' do
        elements :contract_names, 'tbody > tr > td:nth-of-type(1)'
      end

      element :'No received offers', 'div:nth-child(4) > div > span'
      element :'No accepted offers', 'div:nth-child(6) > div > span'
      element :'No contracts', 'div:nth-child(8) > div > span'
      element :'No closed', 'div:nth-child(10) > div > span'
    end
  end
end
