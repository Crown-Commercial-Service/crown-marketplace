module FacilitiesManagement
  module RM3830
    class FrozenRateCard < ApplicationRecord
      include CommonRate

      def self.latest
        rc = order(:updated_at).last
        rc.data.deep_symbolize_keys!
        rc
      end
    end
  end
end
