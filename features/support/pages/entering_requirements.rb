module Pages
  class EnteringRequirements < SitePrism::Page
    section 'Contract details', 'form > table:nth-of-type(1)' do
      section 'Contract name', 'tr:nth-of-type(1)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end

      section 'Estimated annual cost', 'tr:nth-of-type(2)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end

      section 'TUPE', 'tr:nth-of-type(3)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end

      section 'Contract period', 'tr:nth-of-type(4)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end
    end

    section 'Services and buildings', 'form > table:nth-of-type(2)' do
      section 'Services', 'tr:nth-of-type(1)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end

      section 'Buildings', 'tr:nth-of-type(2)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end

      section 'Assigning services to buildings', 'tr:nth-of-type(3)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end

      section 'Service requirements', 'tr:nth-of-type(4)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end
    end

    element :estimated_cost_known_yes, '#facilities_management_procurement_estimated_cost_known_true'
    element :estimated_cost_known_no, '#facilities_management_procurement_estimated_cost_known_false'
    element :estimated_cost_known, '#facilities_management_procurement_estimated_annual_cost'

    element :tupe_yes, '#facilities_management_procurement_tupe_true'
    element :tupe_no, '#facilities_management_procurement_tupe_false'

    element :initial_call_off_period_years, '#facilities_management_procurement_initial_call_off_period_years'
    element :initial_call_off_period_months, '#facilities_management_procurement_initial_call_off_period_months'
    element :initial_call_off_period_day, '#facilities_management_procurement_initial_call_off_start_date_dd'
    element :initial_call_off_period_month, '#facilities_management_procurement_initial_call_off_start_date_mm'
    element :initial_call_off_period_year, '#facilities_management_procurement_initial_call_off_start_date_yyyy'

    element :mobilisation_period_yes, '#facilities_management_procurement_mobilisation_period_required_true'
    element :mobilisation_period_no, '#facilities_management_procurement_mobilisation_period_required_false'
    element :mobilisation_period, '#facilities_management_procurement_mobilisation_period'

    element :extension_required_yes, '#facilities_management_procurement_extensions_required_true'
    element :extension_required_no, '#facilities_management_procurement_extensions_required_false'

    section :optional_call_off_extensions, '#radio-inner-content-for-call-off-extensions' do
      section :'1', '#extension-0-container' do
        element :years, '#facilities_management_procurement_optional_call_off_extensions_attributes_0_years'
        element :months, '#facilities_management_procurement_optional_call_off_extensions_attributes_0_months'
        element :required, '#facilities_management_procurement_optional_call_off_extensions_attributes_0_extension_required'
        elements :error_messages, '.govuk-error-message'
      end

      section :'2', '#extension-1-container' do
        element :years, '#facilities_management_procurement_optional_call_off_extensions_attributes_1_years'
        element :months, '#facilities_management_procurement_optional_call_off_extensions_attributes_1_months'
        element :remove, '#extension-1-remove-button'
        elements :error_messages, '.govuk-error-message'
      end

      section :'3', '#extension-2-container' do
        element :years, '#facilities_management_procurement_optional_call_off_extensions_attributes_2_years'
        element :months, '#facilities_management_procurement_optional_call_off_extensions_attributes_2_months'
        element :remove, '#extension-2-remove-button'
        elements :error_messages, '.govuk-error-message'
      end

      section :'4', '#extension-3-container' do
        element :years, '#facilities_management_procurement_optional_call_off_extensions_attributes_3_years'
        element :months, '#facilities_management_procurement_optional_call_off_extensions_attributes_3_months'
        element :remove, '#extension-3-remove-button'
        elements :error_messages, '.govuk-error-message'
      end

      element :add_extension, '#add-contract-extension-button'
    end

    section :contract_period_summary, '#main-content > table' do
      element :initial_call_off_period_length, '#contract-period > td'
      element :initial_call_off_period, '#contract-period-description > td:nth-child(2)'

      element :mobilisation_period_length, 'tbody > tr:nth-child(3) > td'
      element :mobilisation_period, '#mobilisation-period-description > td:nth-child(2)'

      element :optional_call_off_extension, '#call-off-extension > td'

      element :extension_1_length, '#call-off-extension-0 > td'
      element :extension_2_length, '#call-off-extension-1 > td'
      element :extension_3_length, '#call-off-extension-2 > td'
      element :extension_4_length, '#call-off-extension-3 > td'

      element :extension_1_period, '#call-off-extension-0-description > td:nth-child(2)'
      element :extension_2_period, '#call-off-extension-1-description > td:nth-child(2)'
      element :extension_3_period, '#call-off-extension-2-description > td:nth-child(2)'
      element :extension_4_period, '#call-off-extension-3-description > td:nth-child(2)'
    end

    element :building_status, '.govuk-body > span > strong'
  end
end
