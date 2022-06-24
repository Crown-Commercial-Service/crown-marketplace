require_relative '../entering_requirements'

module Pages::RM6232
  class EnteringRequirements < Pages::EnteringRequirements
    section 'Contract details', Pages::ContractDetailsSection, '#main-content > div:nth-child(3) > div > div:nth-child(2) > table'
    section 'Services and buildings', Pages::ServicesAndBuildingsSection, '#main-content > div:nth-child(3) > div > div:nth-child(3) > table'

    element :annual_contract_value, '#facilities_management_rm6232_procurement_annual_contract_value'

    element :tupe_yes, '#facilities_management_rm6232_procurement_tupe_true'
    element :tupe_no, '#facilities_management_rm6232_procurement_tupe_false'

    element :initial_call_off_period_years, '#facilities_management_rm6232_procurement_initial_call_off_period_years'
    element :initial_call_off_period_months, '#facilities_management_rm6232_procurement_initial_call_off_period_months'
    element :initial_call_off_period_day, '#facilities_management_rm6232_procurement_initial_call_off_start_date_dd'
    element :initial_call_off_period_month, '#facilities_management_rm6232_procurement_initial_call_off_start_date_mm'
    element :initial_call_off_period_year, '#facilities_management_rm6232_procurement_initial_call_off_start_date_yyyy'

    element :mobilisation_period_yes, '#facilities_management_rm6232_procurement_mobilisation_period_required_true'
    element :mobilisation_period_no, '#facilities_management_rm6232_procurement_mobilisation_period_required_false'
    element :mobilisation_period, '#facilities_management_rm6232_procurement_mobilisation_period'

    element :extension_required_yes, '#facilities_management_rm6232_procurement_extensions_required_true'
    element :extension_required_no, '#facilities_management_rm6232_procurement_extensions_required_false'

    section :call_off_extensions, '#radio-inner-content-for-call-off-extensions' do
      section :'1', '#extension-0-container' do
        element :years, '#facilities_management_rm6232_procurement_call_off_extensions_attributes_0_years'
        element :months, '#facilities_management_rm6232_procurement_call_off_extensions_attributes_0_months'
        element :required, '#facilities_management_rm6232_procurement_call_off_extensions_attributes_0_extension_required'
        elements :error_messages, '.govuk-error-message'
      end

      section :'2', '#extension-1-container' do
        element :years, '#facilities_management_rm6232_procurement_call_off_extensions_attributes_1_years'
        element :months, '#facilities_management_rm6232_procurement_call_off_extensions_attributes_1_months'
        element :remove, '#extension-1-remove-button'
        elements :error_messages, '.govuk-error-message'
      end

      section :'3', '#extension-2-container' do
        element :years, '#facilities_management_rm6232_procurement_call_off_extensions_attributes_2_years'
        element :months, '#facilities_management_rm6232_procurement_call_off_extensions_attributes_2_months'
        element :remove, '#extension-2-remove-button'
        elements :error_messages, '.govuk-error-message'
      end

      section :'4', '#extension-3-container' do
        element :years, '#facilities_management_rm6232_procurement_call_off_extensions_attributes_3_years'
        element :months, '#facilities_management_rm6232_procurement_call_off_extensions_attributes_3_months'
        element :remove, '#extension-3-remove-button'
        elements :error_messages, '.govuk-error-message'
      end

      element :add_extension, '#add-contract-extension-button'
    end
  end
end
