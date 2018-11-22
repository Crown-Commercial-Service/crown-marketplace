require 'facilities_management/steps/value_band'

module FacilitiesManagement
  class Journey < ::Journey
    include Rails.application.routes.url_helpers

    def initialize(slug, params)
      paths = JourneyPaths.new(self.class.journey_name)
      first_step_class = Steps::ValueBand
      super(first_step_class, slug, params, paths)
    end

    def self.journey_name
      'facilities-management'
    end

    def start_path
      facilities_management_path
    end

    def next_step_path
      case next_slug
      when 'suppliers'
        facilities_management_suppliers_path(journey: self.class.journey_name, params: params)
      else
        super
      end
    end
  end
end
