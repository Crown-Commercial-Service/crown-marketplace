module FacilitiesManagement
  module RM6232
    class Procurement < ApplicationRecord
      include AASM

      belongs_to :user, inverse_of: :rm6232_procurements

      # The service CAFM – Soft FM Requirements (Q.1) can only be selected when all other services are soft.
      # Because we don't want to pass that logic onto the user, we determine which CAFM service they need for them.
      # To make the selection easier we have added the Q.3 service for the user to select,
      # which we can then replace with the correct CAFM service at the appropriate time.
      # You can read more information at: https://crowncommercialservice.atlassian.net/l/c/XW2DSi72

      def quick_view_suppliers
        @quick_view_suppliers ||= SuppliersSelector.new(service_codes_without_cafm, region_codes, annual_contract_value)
      end

      def services
        @services ||= Service.where(code: true_service_codes).order(:work_package_code, :sort_order)
      end

      def regions
        @regions ||= Region.where(code: region_codes)
      end

      private

      def service_codes_without_cafm
        service_codes - ['Q.3']
      end

      def true_service_codes
        return service_codes unless service_codes.include?('Q.3')

        if lot_number.start_with? '3'
          service_codes_without_cafm + ['Q.1']
        else
          service_codes_without_cafm + ['Q.2']
        end
      end
    end
  end
end
