module Pages::RM3830
  class ContractDetail < SitePrism::Page
    section :contract_details, '#contract-details-summary > table > tbody' do
      section :'Payment method', 'tr:nth-child(2)' do
        element :question, 'a'
        element :answer, 'td:nth-child(2)'
      end

      section :'Invoicing contact details', 'tr:nth-child(3)' do
        element :question, 'a'
        element :answer, 'td:nth-child(2)'
        element :name, '#invoice-detail-summary > details > summary'
        element :contact_detail, '#invoice-detail-summary > details > div'
      end

      section :'Authorised representative details', 'tr:nth-child(4)' do
        element :question, 'a'
        element :answer, 'td:nth-child(2)'
        element :name, '#authorised-detail-summary > details > summary'
        element :contact_detail, '#authorised-detail-summary > details > div'
      end

      section :'Notices contact details', 'tr:nth-child(5)' do
        element :question, 'a'
        element :answer, 'td:nth-child(2)'
        element :name, '#notice-detail-summary > details > summary'
        element :contact_detail, '#notice-detail-summary > details > div'
      end

      section :'Security policy', 'tr:nth-child(6)' do
        element :question, 'a:not([download])'
        element :answer, 'td:nth-child(2)'
      end

      section :'Local Government Pension Scheme', 'tr:nth-child(7)' do
        element :question, 'a:not(.govuk-link--no-visited-state)'
        element :answer, 'td:nth-child(2)'
        elements :pension_schemes, 'ul > li'
      end

      section :'Governing law', 'tr:nth-child(8)' do
        element :question, 'a'
        element :answer, 'td:nth-child(2)'
      end
    end

    section :security_policy_document, '.govuk-radios__conditional' do
      element :name, '#facilities_management_procurement_security_policy_document_name'
      element :number, '#facilities_management_procurement_security_policy_document_version_number'
      element :date_day, '#facilities_management_procurement_security_policy_document_date_dd'
      element :date_month, '#facilities_management_procurement_security_policy_document_date_mm'
      element :date_year, '#facilities_management_procurement_security_policy_document_date_yyyy'
      element :file, '#facilities_management_procurement_security_policy_document_file'
    end

    section :invoicing_contact_detail, 'form' do
      element :Name, '#facilities_management_procurement_invoice_contact_detail_attributes_name'
      element :'Job title', '#facilities_management_procurement_invoice_contact_detail_attributes_job_title'
      element :Email, '#facilities_management_procurement_invoice_contact_detail_attributes_email'
      element :Postcode, '#facilities_management_procurement_invoice_contact_detail_attributes_organisation_address_postcode'
      element :'Building and street', '#facilities_management_procurement_invoice_contact_detail_attributes_organisation_address_line_1'
      element :'Building and street address line 2', '#facilities_management_procurement_invoice_contact_detail_attributes_organisation_address_line_2'
      element :'Town or city', '#facilities_management_procurement_invoice_contact_detail_attributes_organisation_address_town'
      element :County, '#facilities_management_procurement_invoice_contact_detail_attributes_organisation_address_county'
    end

    section :authorised_representative_detail, 'form' do
      element :Name, '#facilities_management_procurement_authorised_contact_detail_attributes_name'
      element :'Job title', '#facilities_management_procurement_authorised_contact_detail_attributes_job_title'
      element :'Telephone number', '#facilities_management_procurement_authorised_contact_detail_attributes_telephone_number'
      element :Email, '#facilities_management_procurement_authorised_contact_detail_attributes_email'
      element :Postcode, '#facilities_management_procurement_authorised_contact_detail_attributes_organisation_address_postcode'
      element :'Building and street', '#facilities_management_procurement_authorised_contact_detail_attributes_organisation_address_line_1'
      element :'Building and street address line 2', '#facilities_management_procurement_authorised_contact_detail_attributes_organisation_address_line_2'
      element :'Town or city', '#facilities_management_procurement_authorised_contact_detail_attributes_organisation_address_town'
      element :County, '#facilities_management_procurement_authorised_contact_detail_attributes_organisation_address_county'
    end

    section :notices_contact_detail, 'form' do
      element :Name, '#facilities_management_procurement_notices_contact_detail_attributes_name'
      element :'Job title', '#facilities_management_procurement_notices_contact_detail_attributes_job_title'
      element :Email, '#facilities_management_procurement_notices_contact_detail_attributes_email'
      element :Postcode, '#facilities_management_procurement_notices_contact_detail_attributes_organisation_address_postcode'
      element :'Building and street', '#facilities_management_procurement_notices_contact_detail_attributes_organisation_address_line_1'
      element :'Building and street address line 2', '#facilities_management_procurement_notices_contact_detail_attributes_organisation_address_line_2'
      element :'Town or city', '#facilities_management_procurement_notices_contact_detail_attributes_organisation_address_town'
      element :County, '#facilities_management_procurement_notices_contact_detail_attributes_organisation_address_county'
    end

    section :contact_detail, 'form' do
      element :name, 'fieldset > div > div:nth-child(2) > label'
      element :address, 'fieldset > div > div:nth-child(2) > label > span'
    end

    element :change_postcode, '#change-input-1'
    element :change_address, '#change-input-2'

    element :cant_find_address_link, '#cant-find-address-link'

    element :buyer_details, '.govuk-radios__input', match: :first

    element :add_pension_fund, '.add-pension-button'
    elements :pension_fund_rows, '.pension-row'
  end
end
