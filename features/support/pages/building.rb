module Pages
  class Building < SitePrism::Page
    element :building_name, '#facilities_management_building_building_name'

    element :postcode_error, '#error_facilities_management_building_address_postcode > span'

    element :address_drop_down, '#address-results-container'
    element :region_drop_down, '#regions-container'
    element :address_text, '#address-text'
    element :region_text, '#region-text'
    element :change_address, '#change-input-2'
    element :change_region, '#change-input-3'

    element :building_status, '#main-content > div:nth-child(3) > div > strong'

    element :step_number, '#main-content > div.govuk-grid-row > div > span.govuk-caption-m'

    section :building_details_summary, '.govuk-summary-list' do
      section :Name, '.govuk-summary-list__row:nth-of-type(1)' do
        element :value, '.govuk-summary-list__value'
        element :link, 'a'
      end

      section :Description, '.govuk-summary-list__row:nth-of-type(2)' do
        element :value, '.govuk-summary-list__value'
        element :link, 'a'
      end

      section :Address, '.govuk-summary-list__row:nth-of-type(3)' do
        element :value, '.govuk-summary-list__value'
        element :link, 'a'
      end

      section :Region, '.govuk-summary-list__row:nth-of-type(4)' do
        element :value, '.govuk-summary-list__value'
        element :link, 'a'
      end

      section :'Gross internal area', '.govuk-summary-list__row:nth-of-type(5)' do
        element :value, '.govuk-summary-list__value'
        element :link, 'a'
      end

      section :'External area', '.govuk-summary-list__row:nth-of-type(6)' do
        element :value, '.govuk-summary-list__value'
        element :link, 'a'
      end

      section :'Building type', '.govuk-summary-list__row:nth-of-type(7)' do
        element :value, '.govuk-summary-list__value'
        element :link, 'a'
      end

      section :'Security clearance', '.govuk-summary-list__row:nth-of-type(8)' do
        element :value, '.govuk-summary-list__value'
        element :link, 'a'
      end
    end

    section :building_input, 'form' do
      element :name, '#facilities_management_building_building_name'
      element :description, '#facilities_management_building_description'
      element :GIA, '#facilities_management_building_gia'
      element :'external area', '#facilities_management_building_external_area'
    end
  end
end
