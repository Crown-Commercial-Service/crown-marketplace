module Pages
  class Admin < SitePrism::Page
    section :supplier_details, '#main-content' do
      element :supplier_name_title, 'span'

      section :'Current user', '#supplier-details--supplier_user' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'Supplier status', '#supplier-details--supplier_status' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'Supplier name', '#supplier-details--supplier_name' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'Contact name', '#supplier-details--contact_name' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'Contact email', '#supplier-details--contact_email' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'Contact telephone number', '#supplier-details--contact_phone' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'DUNS number', '#supplier-details--duns' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'Company registration number', '#supplier-details--registration_number' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end

      section :'Full address', '#supplier-details--full_address' do
        element :change_link, 'dd.govuk-summary-list__actions > a'
        element :detail, 'dd.govuk-summary-list__value'
      end
    end
  end
end
