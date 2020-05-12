module CCS
  module FM
    class FrozenRateCard < ApplicationRecord
      include CommonRate

      # rubocop:disable Rails/FindBy
      def self.latest
        rc = where(updated_at: CCS::FM::FrozenRateCard.select('max(updated_at)')).first
        rc.data.deep_symbolize_keys!
        rc
      end
      # rubocop:enable Rails/FindBy
    end
  end
end
