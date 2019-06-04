module CCS
  module FM
    # CCS::FM::UnitsOfMeasurement.all

    def self.table_name_prefix
      'fm_'
    end

    class UnitsOfMeasurement < ApplicationRecord
      self.table_name = 'fm_units_of_measurement'
      # usage:
      # CCS::FM::UnitsOfMeasurement.where('C.5')
      # CCS::FM::UnitsOfMeasurement.where("? = ANY(service_usage)", 'C.5')
      def self.service_usage(service)
        # CCS::FM::UnitsOfMeasurement.where(service_usage: service)
        where('? = ANY(service_usage)', service).order(:id)
      end
    end
  end
end
