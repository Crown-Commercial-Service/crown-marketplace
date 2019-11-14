module FacilitiesManagement
  class BuyerDetails
    def buyer_details_incomplete?(current_user)
      # used to assist the site in determining if the user
      # is a buyer and if they are required to complete information in
      # the buyer-account details page

      if current_user.has_role? :buyer
        current_user.buyer_detail.present? && current_user.buyer_detail&.valid?(:update)
      else
        false
      end
    rescue StandardError => e
      Rails.logger.warn "Couldn't retrieve buyer details: #{e}"
      true
    end
  end
end
