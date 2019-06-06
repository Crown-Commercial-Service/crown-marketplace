module CCS
  module FM
    # CCS::FM::UnitsOfMeasurement.all

    def self.table_name_prefix
      'fm_'
    end

    class UnitsOfMeasurement < ApplicationRecord
      self.table_name = 'fm_units_of_measurement'
      # usage:
      #   CCS::FM::UnitsOfMeasurement.where('C.5')
      #   CCS::FM::UnitsOfMeasurement.where("? = ANY(service_usage)", 'C.5')
      #   CCS::FM::UnitsOfMeasurement.service_usage('H.5')
      #   CCS::FM::UnitsOfMeasurement.service_usage('C.10')
      def self.service_usage(service)
        vals = where('? = ANY(service_usage)', service).order(:id)
        vals.as_json
      end
    end
  end
end
