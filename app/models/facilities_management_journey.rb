class FacilitiesManagementJourney < Journey
  include Rails.application.routes.url_helpers

  def initialize(slug, params)
    paths = JourneyPaths.new(self.class.journey_name)
    first_step_class = Steps::ValueBand
    super(first_step_class, slug, params, paths)
  end

  def self.journey_name
    'fm'
  end

  def start_path
    facilities_management_path
  end

  def next_step_path
    case next_slug
    when 'lot1a-suppliers'
      facilities_management_lot1a_suppliers_path(journey: self.class.journey_name, params: params)
    when 'lot1b-suppliers'
      facilities_management_lot1b_suppliers_path(journey: self.class.journey_name, params: params)
    when 'lot1c-suppliers'
      facilities_management_lot1c_suppliers_path(journey: self.class.journey_name, params: params)
    else
      super
    end
  end
end
