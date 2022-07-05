module Pages
  class SupplierDetailsSection < SitePrism::Section
    element :change_link, 'dd.govuk-summary-list__actions > a'
    element :detail, 'dd.govuk-summary-list__value'
  end

  class Admin < SitePrism::Page
    section :supplier_details, '#main-content' do
      element :supplier_name_title, 'span'

      section :'Current user', SupplierDetailsSection, '#supplier-details--supplier_user'
      section :'Supplier status', SupplierDetailsSection, '#supplier-details--supplier_status'
      section :'Supplier name', SupplierDetailsSection, '#supplier-details--supplier_name'
      section :'Contact name', SupplierDetailsSection, '#supplier-details--contact_name'
      section :'Contact email', SupplierDetailsSection, '#supplier-details--contact_email'
      section :'Contact telephone number', SupplierDetailsSection, '#supplier-details--contact_phone'
      section :'DUNS number', SupplierDetailsSection, '#supplier-details--duns'
      section :'Company registration number', SupplierDetailsSection, '#supplier-details--registration_number'
      section :'Full address', SupplierDetailsSection, '#supplier-details--full_address'
    end

    section :management_report, 'form' do
      element :'From day', '#facilities_management_rm3830_admin_management_report_start_date_dd'
      element :'From month', '#facilities_management_rm3830_admin_management_report_start_date_mm'
      element :'From year', '#facilities_management_rm3830_admin_management_report_start_date_yyyy'

      element :'To day', '#facilities_management_rm3830_admin_management_report_end_date_dd'
      element :'To month', '#facilities_management_rm3830_admin_management_report_end_date_mm'
      element :'To year', '#facilities_management_rm3830_admin_management_report_end_date_yyyy'
    end

    element :management_report_date, '#main-content > div:nth-child(4) > div > p:nth-child(2)'
    elements :management_reports, '#main-content > div:nth-child(5) > div > table > tbody > tr'
  end
end
