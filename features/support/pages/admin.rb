module Pages
  class Admin < SitePrism::Page
    section :supplier_details, '#main-content' do
      section :'Current user', 'div:nth-child(5) > div > dl > div' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'Supplier name', 'div:nth-child(6) > div > dl > div:nth-child(1)' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'Contact name', 'div:nth-child(6) > div > dl > div:nth-child(2)' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'Contact email', 'div:nth-child(6) > div > dl > div:nth-child(3)' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'Contact telephone number', 'div:nth-child(6) > div > dl > div:nth-child(4)' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'DUNS number', 'div:nth-child(7) > div > dl > div:nth-child(1)' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'Company registration number', 'div:nth-child(7) > div > dl > div:nth-child(2)' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'Full address', 'div:nth-child(7) > div > dl > div:nth-child(3)' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end
    end

    section :supplier_detail_form, 'form' do
      element :'User email', '#facilities_management_admin_suppliers_admin_user_email'
      element :'Supplier name', '#facilities_management_admin_suppliers_admin_supplier_name'
      element :'Contact name', '#facilities_management_admin_suppliers_admin_contact_name'
      element :'Contact email', '#facilities_management_admin_suppliers_admin_contact_email'
      element :'Contact telephone number', '#facilities_management_admin_suppliers_admin_contact_phone'
      element :'DUNS number', '#facilities_management_admin_suppliers_admin_duns'
      element :'Company registration number', '#facilities_management_admin_suppliers_admin_registration_number'
    end

    section :management_report, 'form' do
      element :'From day', '#facilities_management_admin_management_report_start_date_dd'
      element :'From month', '#facilities_management_admin_management_report_start_date_mm'
      element :'From year', '#facilities_management_admin_management_report_start_date_yyyy'

      element :'To day', '#facilities_management_admin_management_report_end_date_dd'
      element :'To month', '#facilities_management_admin_management_report_end_date_mm'
      element :'To year', '#facilities_management_admin_management_report_end_date_yyyy'
    end

    element :management_report_date, 'h3'
  end
end
