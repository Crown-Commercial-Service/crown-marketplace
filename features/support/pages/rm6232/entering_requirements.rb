module Pages::RM6232
  class EnteringRequirements < SitePrism::Page
    section 'Contract details', '#main-content > div:nth-child(3) > div > div:nth-child(2) > table' do
      section 'Contract name', 'tr:nth-of-type(1)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end

      section 'Annual contract value', 'tr:nth-of-type(2)' do
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

    section 'Services and buildings', '#main-content > div:nth-child(3) > div > div:nth-child(3) > table' do
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
    end

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

    section :contract_period_summary, '#main-content > div:nth-child(3) > div > table' do
      element :initial_call_off_period_length, '#contract-period > td'
      element :initial_call_off_period, '#contract-period-description > td:nth-child(2)'

      element :mobilisation_period_length, 'tbody > tr:nth-child(3) > td'
      element :mobilisation_period, '#mobilisation-period-description > td:nth-child(2)'

      element :call_off_extension, '#call-off-extension > td'

      element :extension_1_length, '#call-off-extension-0 > td'
      element :extension_2_length, '#call-off-extension-1 > td'
      element :extension_3_length, '#call-off-extension-2 > td'
      element :extension_4_length, '#call-off-extension-3 > td'

      element :extension_1_period, '#call-off-extension-0-description > td:nth-child(2)'
      element :extension_2_period, '#call-off-extension-1-description > td:nth-child(2)'
      element :extension_3_period, '#call-off-extension-2-description > td:nth-child(2)'
      element :extension_4_period, '#call-off-extension-3-description > td:nth-child(2)'
    end

    element :number_of_selected_servcies, '#number-of-services'
    element :number_of_selected_buildings, '#number-of-buildings'

    element :no_buildings_text, 'form > div.procurement > div:nth-child(5)'
    elements :checked_buildings, 'input[checked="checked"]'

    # element :building_status, '.govuk-body > span > strong'
    # element :assigning_services_to_buildings_status, '.govuk-body > span > strong'

    # element :select_all_services_checkbox, '#box-all'
    # elements :all_checkboxes, 'input[type=checkbox]'

    # element :next_pagination, 'li.ccs-last > button'
    # element :previous_pagination, 'li.ccs-first > button'

    # element :region_drop_down, '#facilities_management_building_address_region'
  end
end
