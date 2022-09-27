module Pages
  class BuildingDetailsSection < SitePrism::Section
    element :value, '.govuk-summary-list__value'
    element :link, 'a'
  end

  class Building < SitePrism::Page
    element :building_name, '#facilities_management_building_building_name'

    element :postcode_error, '#address_postcode-error'

    element :address_drop_down, '#address-results-container'
    element :region_drop_down, '#regions-results-container'
    element :address_text, '#address-text'
    element :region_text, '#region-text'
    element :change_address, '#change-input-2'
    element :change_region, '#change-input-3'

    element :building_status, '#main-content > div:nth-child(3) > div > strong'

    element :step_number, '#main-content > div.govuk-grid-row > div > span.govuk-caption-m'

    section :building_details_summary, '.govuk-summary-list' do
      section :Name, BuildingDetailsSection, '.govuk-summary-list__row:nth-of-type(1)'
      section :Description, BuildingDetailsSection, '.govuk-summary-list__row:nth-of-type(2)'
      section :Address, BuildingDetailsSection, '.govuk-summary-list__row:nth-of-type(3)'
      section :Region, BuildingDetailsSection, '.govuk-summary-list__row:nth-of-type(4)'
      section :'Gross internal area', BuildingDetailsSection, '.govuk-summary-list__row:nth-of-type(5)'
      section :'External area', BuildingDetailsSection, '.govuk-summary-list__row:nth-of-type(6)'
      section :'Building type', BuildingDetailsSection, '.govuk-summary-list__row:nth-of-type(7)'
      section :'Security clearance', BuildingDetailsSection, '.govuk-summary-list__row:nth-of-type(8)'
    end

    section :building_input, 'form' do
      element :name, '#facilities_management_building_building_name'
      element :description, '#facilities_management_building_description'
      element :GIA, '#facilities_management_building_gia'
      element :'external area', '#facilities_management_building_external_area'
    end
  end
end
