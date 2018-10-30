class FacilitiesManagementJourney < Journey
  include Rails.application.routes.url_helpers

  def initialize(slug, params)
    first_step_class = Steps::ValueBand
    super(self.class.journey_name, first_step_class, slug, params)
  end

  def self.journey_name
    'fm'
  end

  def start_path
    facilities_management_path
  end
end
