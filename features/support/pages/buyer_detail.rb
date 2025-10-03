module Pages
  class SummaryRowRowSection < SitePrism::Section
    element :key, 'dt.govuk-summary-list__key'
    element :value, 'dd.govuk-summary-list__value'
  end

  class BuyerDetail < SitePrism::Page
    section :buyer_details, '#main-content' do
      section :'Personal details', '#buyer-details-summery--personal-details' do
        sections :rows, SummaryRowRowSection, 'govuk-summary-list__row'
      end
      section :'Organisation details', '#buyer-details-summery--organisation-details' do
        sections :rows, SummaryRowRowSection, 'govuk-summary-list__row'
      end
      section :'Contact preferences', '#buyer-details-summery--contact-preferences' do
        sections :rows, SummaryRowRowSection, 'govuk-summary-list__row'
      end
    end

    section :sector, '#sector-form-group' do
      element :'Defence and Security', '#facilities_management_buyer_detail_sector_defence_and_security'
      element :Health, '#facilities_management_buyer_detail_sector_health'
      element :'Government Policy', '#facilities_management_buyer_detail_sector_government_policy'
      element :'Local Community and Housing', '#facilities_management_buyer_detail_sector_local_community_and_housing'
      element :Infrastructure, '#facilities_management_buyer_detail_sector_infrastructure'
      element :Education, '#facilities_management_buyer_detail_sector_education'
      element :'Culture, Media and Sport', '#facilities_management_buyer_detail_sector_culture_media_and_sport'
    end

    section :contact_opt_in, '#contact_opt_in-form-group' do
      element :Yes, '#facilities_management_buyer_detail_contact_opt_in_true'
      element :No, '#facilities_management_buyer_detail_contact_opt_in_false'
    end

    element :address_line_1_error_message, '#organisation_address_line_1-error'
    element :town_or_city_error_message, '#organisation_address_town-error'
    element :postcode_error_message, '#organisation_address_postcode-error'
    element :address_drop_down, '#organisation_address'
    element :change_address, '#organisation-address--change-address-button'
  end
end
