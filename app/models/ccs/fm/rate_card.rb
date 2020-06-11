module CCS
  module FM
    class RateCard < ApplicationRecord
      include CommonRateCard

      # rubocop:disable Rails/FindBy
      def self.latest
        rc = where(updated_at: CCS::FM::RateCard.select('max(updated_at)')).first
        rc.data.deep_symbolize_keys!
        rc
      end
      # rubocop:enable Rails/FindBy
    end
  end
end
