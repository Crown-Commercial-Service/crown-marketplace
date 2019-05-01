module CCS
  module FM
    # CCS::FM::Rate.all

    def self.table_name_prefix
      'fm_'
    end

    class Rate < ApplicationRecord
      # usage:
      # CCS::FM::Rate.zero_rate
      # CCS::FM::Rate.zero_rate.map(&:code)
      def self.zero_rate
        CCS::FM::Rate.all.where(framework: 0, benchmark: 0)
      end

      # CCS::FM::Rate.non_zero_rate
      # CCS::FM::Rate.non_zero_rate.map(&:code)
      def self.non_zero_rate
        CCS::FM::Rate.all.where('framework <> 0 and  benchmark <> 0')
      end
    end
  end
end
