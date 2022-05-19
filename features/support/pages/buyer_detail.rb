module Pages
  class BuyerDetail < SitePrism::Page
    section :buyer_details, '#main-content' do
      element :Name, '#facilities_management_buyer_detail_full_name'
      element :'Job title', '#facilities_management_buyer_detail_job_title'
      element :'Telephone number', '#facilities_management_buyer_detail_telephone_number'
      element :'Organisation name', '#facilities_management_buyer_detail_organisation_name'
      element :'Organisation address', '#address-text'
    end

    section :sector, '#central_government-form-group' do
      element :'Central government', '#facilities_management_buyer_detail_central_government_true'
      element :'Wider public sector', '#facilities_management_buyer_detail_central_government_false'
    end

    element :postcode_error_message, '#error_facilities_management_buyer_detail_organisation_address_postcode > span'
  end
end
