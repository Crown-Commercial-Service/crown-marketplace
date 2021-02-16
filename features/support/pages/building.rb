module Pages
  class Building < SitePrism::Page
    element :building_name, '#facilities_management_building_building_name'

    element :postcode_error, '#error_facilities_management_building_address_postcode > span'

    element :address_drop_down, '#address-results-container'
    element :region_drop_down, '#regions-container'
    element :address_text, '#address-text'
    element :region_text, '#region-text'
    element :change_region, '#change-input-3'

    element :building_status, '.govuk-body > strong'

    section :building_details_summary, 'table > tbody' do
      section :Name, 'tr:nth-of-type(1)' do
        element :value, 'td:nth-of-type(1)'
        element :link, 'a'
      end

      section :Description, 'tr:nth-of-type(2)' do
        element :value, 'td:nth-of-type(1)'
        element :link, 'a'
      end

      section :Address, 'tr:nth-of-type(3)' do
        element :value, 'td:nth-of-type(1)'
        element :link, 'a'
      end

      section :Region, 'tr:nth-of-type(4)' do
        element :value, 'td:nth-of-type(1)'
        element :link, 'a'
      end

      section :'Gross internal area', 'tr:nth-of-type(5)' do
        element :value, 'td:nth-of-type(1)'
        element :link, 'a'
      end

      section :'External area', 'tr:nth-of-type(6)' do
        element :value, 'td:nth-of-type(1)'
        element :link, 'a'
      end

      section :'Building type', 'tr:nth-of-type(7)' do
        element :value, 'td:nth-of-type(1)'
        element :link, 'a'
      end

      section :'Security clearance', 'tr:nth-of-type(8)' do
        element :value, 'td:nth-of-type(1)'
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
