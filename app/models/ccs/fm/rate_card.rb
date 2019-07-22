module CCS
  module FM
    class RateCard < ApplicationRecord
      # Event.where("payload->>'kind' = ?", "user_renamed")

      # rubocop:disable Rails/FindBy
      def self.latest
        where(updated_at: CCS::FM::RateCard.select('max(updated_at)')).first
      end
      # rubocop:enable Rails/FindBy
    end
  end
end
