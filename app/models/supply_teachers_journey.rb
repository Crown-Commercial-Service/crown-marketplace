class SupplyTeachersJourney < Journey
  include Rails.application.routes.url_helpers

  def initialize(slug, params)
    paths = JourneyPaths.new(self.class.journey_name)
    super(self.class.first_step_class, slug, params, paths)
  end

  def self.journey_name
    'teacher-supply'
  end

  def self.first_step_class
    Steps::LookingFor
  end

  def start_path
    supply_teachers_path
  end

  def next_step_path
    case next_slug
    when 'results'
      branches_path(params: params)
    when 'master-vendor-managed-service'
      master_vendors_path(journey: self.class.journey_name, params: params)
    when 'neutral-vendor-managed-service'
      neutral_vendors_path(journey: self.class.journey_name, params: params)
    else
      super
    end
  end
end
