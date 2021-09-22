module FacilitiesManagement
  module RM3830
    class RateCard < ApplicationRecord
      include CommonRateCard

      def self.latest
        rc = order(:updated_at).last
        rc.data.deep_symbolize_keys!
        rc
      end
    end
  end
end
