module FacilitiesManagement
  module RM3830
    class UnitsOfMeasurement < ApplicationRecord
      def self.service_usage(service)
        vals = where('? = ANY(service_usage)', service).order(:id)
        vals.as_json
      end
    end
  end
end
