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
        vals = vals.as_json
        services = ['C.1', 'C.10', 'C.11', 'C.12', 'C.13', 'C.14', 'C.15', 'C.16', 'C.17', 'C.18', 'C.2', 'C.20', 'C.3', 'C.4', 'C.6', 'C.7', 'C.8', 'C.9', 'D.1', 'D.2', 'D.4', 'D.5', 'D.6', 'E.1', 'E.2', 'E.3', 'E.5', 'E.6', 'E.7', 'E.8', 'F.1', 'G.1', 'G.10', 'G.11', 'G.14', 'G.15', 'G.16', 'G.2', 'G.3', 'G.4', 'G.6', 'G.7', 'G.9', 'H.1', 'H.10', 'H.11', 'H.13', 'H.2', 'H.3', 'H.6', 'H.7', 'H.8', 'H.9', 'J.10', 'J.11', 'J.7', 'J.9', 'L.2', 'L.3', 'L.4', 'L.5']
        if services.include? service
          vals <<
            {
              'title_text' => 'What is the total internal area of this building?',
              'example_text' => 'For example, 18000 sqm. When the gross internal area (GIA) measures 18,000 sqm',
              'service_usage' => [service]
            }
        end
        vals
      end
    end
  end
end
