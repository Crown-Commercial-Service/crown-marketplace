module CCS
  module FM
    # CCS::FM::Rate.all

    def self.table_name_prefix
      'fm_'
    end

    class RateCard < ApplicationRecord
      # usage:
      # CCS::FM::RateCard.zero_rate
      # CCS::FM::RateCard.zero_rate.map(&:code)
      def self.zero_rate
        where(framework: 0, benchmark: 0)
      end

      # CCS::FM::RateCard.non_zero_rate
      # CCS::FM::RateCard.non_zero_rate.map(&:code)
      def self.non_zero_rate
        where('framework <> 0 and  benchmark <> 0')
      end
    end
  end
end
