module Pages
  class DetailSection < SitePrism::Section
    element :name, 'td:nth-of-type(1)'
    element :status, 'td:nth-of-type(2)'
  end

  class ContractDetailsSection < SitePrism::Section
    section 'Contract name', DetailSection, 'tr:nth-of-type(1)'
    section 'Estimated annual cost', DetailSection, 'tr:nth-of-type(2)'
    section 'Annual contract value', DetailSection, 'tr:nth-of-type(2)'
    section 'TUPE', DetailSection, 'tr:nth-of-type(3)'
    section 'Contract period', DetailSection, 'tr:nth-of-type(4)'
  end

  class ServicesAndBuildingsSection < SitePrism::Section
    section 'Services', DetailSection, 'tr:nth-of-type(1)'
    section 'Buildings', DetailSection, 'tr:nth-of-type(2)'
    section 'Assigning services to buildings', DetailSection, 'tr:nth-of-type(3)'
    section 'Service requirements', DetailSection, 'tr:nth-of-type(4)'
  end

  class EnteringRequirements < SitePrism::Page
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

    element :no_buildings_text, '#procurement_buildings-form-group > div:nth-child(2) > div > p'
    elements :checked_buildings, 'input[checked="checked"]'

    element :building_status, '.govuk-body > span > strong'
    element :assigning_services_to_buildings_status, '#main-content > div:nth-child(3) > div > span.govuk-\!-padding-left-2 > strong'

    element :select_all_services_checkbox, '#box-all'
    elements :all_checkboxes, 'input[type=checkbox]'

    element :next_pagination, 'li.ccs-last > button'
    element :previous_pagination, 'li.ccs-first > button'

    element :region_drop_down, '#facilities_management_building_address_region'
  end
end
