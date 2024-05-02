module Pages
  class BuyerDetail < SitePrism::Page
    section :buyer_details, '#main-content' do
      element :Name, '#facilities_management_buyer_detail_full_name'
      element :'Job title', '#facilities_management_buyer_detail_job_title'
      element :'Telephone number', '#facilities_management_buyer_detail_telephone_number'
      element :'Organisation name', '#facilities_management_buyer_detail_organisation_name'
      element :'Organisation address', '#address-text'
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

    element :postcode_error_message, '#organisation_address_postcode-error'
    element :address_drop_down, '#address-results-container'
    element :change_address, '#change-input-2'
  end
end
