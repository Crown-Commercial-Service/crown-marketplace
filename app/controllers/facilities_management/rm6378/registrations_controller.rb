module FacilitiesManagement
  module RM6378
    class RegistrationsController < FacilitiesManagement::RegistrationsController
      private

      def fm_access
        :fm_access
      end
    end
  end
end
