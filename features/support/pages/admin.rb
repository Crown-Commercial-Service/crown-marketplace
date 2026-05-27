module Pages
  class SupplierDetailsSection < SitePrism::Section
    element :change_link, 'dd.govuk-summary-list__actions > a'
    element :detail, 'dd.govuk-summary-list__value'
  end

  class SummaryList < SitePrism::Section
    element :key, '.govuk-summary-list__key'
    element :value, '.govuk-summary-list__value'
  end

  class SummarySection < SitePrism::Section
    element :heading, 'p'
    elements :items, 'ul > li'
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

    element :management_report_date, '#main-content > div:nth-child(2) > div > p:nth-child(2)'
    elements :management_reports, '#main-content > div:nth-child(3) > div > table > tbody > tr'

    element :supplier_search_input, '#table_filter'

    sections :suppliers, '#suppliers-table > tbody > tr', visible: true do
      element :supplier_name, 'th'
      element :'View details', 'td:nth-child(2) > a'
      element :'View lot data', 'td:nth-child(3) > a'
    end

    sections :'Supplier information', SummaryList, '#supplier-details--supplier-information > .govuk-summary-list__row'
    sections :'Contact information', SummaryList, '#supplier-details--contact-information > .govuk-summary-list__row'
    sections :'Additional information', SummaryList, '#supplier-details--additional-information > .govuk-summary-list__row'

    sections :supplier_lots, '.supplier-lot-data--lots' do
      element :lot_name, 'h2'
      sections :lot_info, SummaryList, '.govuk-summary-list > .govuk-summary-list__row'
    end

    sections :supplier_section_summaries, '.govuk-summary-card' do
      element :title, '.govuk-summary-card__title'
      element :empty_message, 'p.govuk-body'
      sections :section_items, SummarySection, '.govuk-summary-card__content > .section-list-group'
    end
  end
end
