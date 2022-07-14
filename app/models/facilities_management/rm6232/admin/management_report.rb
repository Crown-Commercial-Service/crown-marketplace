module FacilitiesManagement
  module RM6232
    module Admin
      class ManagementReport < FacilitiesManagement::Admin::ManagementReport
        belongs_to :user, inverse_of: :rm6232_management_reports

        acts_as_gov_uk_date :start_date, :end_date, error_clash_behaviour: :omit_gov_uk_date_field_error
      end
    end
  end
end
