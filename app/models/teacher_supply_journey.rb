class TeacherSupplyJourney < Journey
  include Rails.application.routes.url_helpers

  def initialize(slug, params)
    first_step_class = Steps::LookingFor
    super(first_step_class, slug, params)
  end

  def form_path
    search_answer_path(slug: current_slug)
  end

  def current_question_path
    search_question_path(slug: current_slug, params: params)
  end

  def back_path
    search_question_path(slug: previous_slug, params: params)
  end

  def next_step_path
    case next_slug
    when 'results'
      branches_path(params: params)
    when 'master-vendor-managed-service'
      master_vendors_path(params)
    when 'neutral-vendor-managed-service'
      neutral_vendors_path(params)
    else
      search_question_path(slug: next_slug, params: params)
    end
  end
end
