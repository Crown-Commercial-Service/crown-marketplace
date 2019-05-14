module CCS
  module FM
    # CCS::FM::UnitsOfMeasurement.all

    def self.table_name_prefix
      'fm_'
    end

    class UnitsOfMeasurement < ApplicationRecord
      # usage:
      # CCS::FM::Rate.zero_rate
      # CCS::FM::Rate.service_usage.map(&:code)
      def self.service_usage(service)
        CCS::FM::UnitsOfMeasurement.where(service_usage: service)
      end
    end
  end
end
