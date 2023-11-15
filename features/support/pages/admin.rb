module Pages
  class SupplierDetailsSection < SitePrism::Section
    element :change_link, 'dd.govuk-summary-list__actions > a'
    element :detail, 'dd.govuk-summary-list__value'
  end

  class Admin < SitePrism::Page
    section :supplier_details, '#main-content' do
      element :supplier_name_title, 'h1 > span'

      section :'Current user', SupplierDetailsSection, :xpath, '//dl/div/dt[@class="govuk-summary-list__key"][text()="Current user"]/..'
      section :'Supplier status', SupplierDetailsSection, :xpath, '//dl/div/dt[@class="govuk-summary-list__key"][text()="Current status"]/..'
      section :'Supplier name', SupplierDetailsSection, :xpath, '//dl/div/dt[@class="govuk-summary-list__key"][text()="Supplier name"]/..'
      section :'Contact name', SupplierDetailsSection, :xpath, '//dl/div/dt[@class="govuk-summary-list__key"][text()="Contact name"]/..'
      section :'Contact email', SupplierDetailsSection, :xpath, '//dl/div/dt[@class="govuk-summary-list__key"][text()="Contact email"]/..'
      section :'Contact telephone number', SupplierDetailsSection, :xpath, '//dl/div/dt[@class="govuk-summary-list__key"][text()="Contact telephone number"]/..'
      section :'DUNS number', SupplierDetailsSection, :xpath, '//dl/div/dt[@class="govuk-summary-list__key"][text()="DUNS number"]/..'
      section :'Company registration number', SupplierDetailsSection, :xpath, '//dl/div/dt[@class="govuk-summary-list__key"][text()="Company registration number"]/..'
      section :'Full address', SupplierDetailsSection, :xpath, '//dl/div/dt[@class="govuk-summary-list__key"][text()="Full address"]/..'
    end

    element :management_report_date, '#main-content > div:nth-child(4) > div > p:nth-child(2)'
    elements :management_reports, '#main-content > div:nth-child(5) > div > table > tbody > tr'
  end
end
