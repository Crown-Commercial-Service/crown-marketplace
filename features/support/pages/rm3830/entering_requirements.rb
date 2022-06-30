require_relative '../entering_requirements'

module Pages::RM3830
  class EnteringRequirements < Pages::EnteringRequirements
    section 'Contract details', Pages::ContractDetailsSection, 'form > table:nth-of-type(1)'
    section 'Services and buildings', Pages::ServicesAndBuildingsSection, 'form > table:nth-of-type(2)'

    element :estimated_cost_known_yes, '#facilities_management_rm3830_procurement_estimated_cost_known_true'
    element :estimated_cost_known_no, '#facilities_management_rm3830_procurement_estimated_cost_known_false'
    element :estimated_cost_known, '#facilities_management_rm3830_procurement_estimated_annual_cost'

    element :tupe_yes, '#facilities_management_rm3830_procurement_tupe_true'
    element :tupe_no, '#facilities_management_rm3830_procurement_tupe_false'

    element :initial_call_off_period_years, '#facilities_management_rm3830_procurement_initial_call_off_period_years'
    element :initial_call_off_period_months, '#facilities_management_rm3830_procurement_initial_call_off_period_months'
    element :initial_call_off_period_day, '#facilities_management_rm3830_procurement_initial_call_off_start_date_dd'
    element :initial_call_off_period_month, '#facilities_management_rm3830_procurement_initial_call_off_start_date_mm'
    element :initial_call_off_period_year, '#facilities_management_rm3830_procurement_initial_call_off_start_date_yyyy'

    element :mobilisation_period_yes, '#facilities_management_rm3830_procurement_mobilisation_period_required_true'
    element :mobilisation_period_no, '#facilities_management_rm3830_procurement_mobilisation_period_required_false'
    element :mobilisation_period, '#facilities_management_rm3830_procurement_mobilisation_period'

    element :extension_required_yes, '#facilities_management_rm3830_procurement_extensions_required_true'
    element :extension_required_no, '#facilities_management_rm3830_procurement_extensions_required_false'

    section :call_off_extensions, '#radio-inner-content-for-call-off-extensions' do
      section :'1', '#extension-0-container' do
        element :years, '#facilities_management_rm3830_procurement_call_off_extensions_attributes_0_years'
        element :months, '#facilities_management_rm3830_procurement_call_off_extensions_attributes_0_months'
        element :required, '#facilities_management_rm3830_procurement_call_off_extensions_attributes_0_extension_required'
        elements :error_messages, '.govuk-error-message'
      end

      section :'2', '#extension-1-container' do
        element :years, '#facilities_management_rm3830_procurement_call_off_extensions_attributes_1_years'
        element :months, '#facilities_management_rm3830_procurement_call_off_extensions_attributes_1_months'
        element :remove, '#extension-1-remove-button'
        elements :error_messages, '.govuk-error-message'
      end

      section :'3', '#extension-2-container' do
        element :years, '#facilities_management_rm3830_procurement_call_off_extensions_attributes_2_years'
        element :months, '#facilities_management_rm3830_procurement_call_off_extensions_attributes_2_months'
        element :remove, '#extension-2-remove-button'
        elements :error_messages, '.govuk-error-message'
      end

      section :'4', '#extension-3-container' do
        element :years, '#facilities_management_rm3830_procurement_call_off_extensions_attributes_3_years'
        element :months, '#facilities_management_rm3830_procurement_call_off_extensions_attributes_3_months'
        element :remove, '#extension-3-remove-button'
        elements :error_messages, '.govuk-error-message'
      end

      element :add_extension, '#add-contract-extension-button'
    end
  end
end
