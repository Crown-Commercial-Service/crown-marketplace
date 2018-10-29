class TeacherSupplyJourney < Journey
  include Rails.application.routes.url_helpers

  def initialize(slug, params)
    first_step_class = Steps::LookingFor
    super(first_step_class, slug, params)
  end

  def self.journey_name
    'teacher-supply'
  end

  def form_path
    journey_answer_path(journey: self.class.journey_name, slug: current_slug)
  end

  def current_question_path
    journey_question_path(journey: self.class.journey_name, slug: current_slug, params: params)
  end

  def back_path
    journey_question_path(journey: self.class.journey_name, slug: previous_slug, params: params)
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
      journey_question_path(journey: self.class.journey_name, slug: next_slug, params: params)
    end
  end
end
