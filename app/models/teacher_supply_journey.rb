class TeacherSupplyJourney < Journey
  def initialize(slug, params)
    first_step_class = Steps::LookingFor
    super(first_step_class, slug, params)
  end

  def self.journey_name
    'teacher-supply'
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
