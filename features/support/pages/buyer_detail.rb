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

    section :contact_opt_in, '#contact_opt_in-form-group' do
      element :Yes, '#facilities_management_buyer_detail_contact_opt_in_true'
      element :No, '#facilities_management_buyer_detail_contact_opt_in_false'
    end

    element :postcode_error_message, '#organisation_address_postcode-error'
    element :change_address, '#change-input-2'
  end
end
