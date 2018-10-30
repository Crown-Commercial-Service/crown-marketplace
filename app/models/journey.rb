class Journey
  class JourneyPaths
    include Rails.application.routes.url_helpers

    def initialize(journey_name)
      @journey_name = journey_name
    end

    def home
      homepage_path
    end

    def question(slug, params = nil)
      if params
        journey_question_path(journey: @journey_name,
                              slug: slug,
                              params: params)
      else
        journey_question_path(journey: @journey_name,
                              slug: slug)
      end
    end

    def answer(slug)
      journey_answer_path(journey: @journey_name, slug: slug)
    end
  end

  attr_reader :steps, :params

  def initialize(journey_name, first_step_class, slug, params)
    @steps = []
    @params = {}
    @paths = JourneyPaths.new(journey_name)

    klass = first_step_class
    loop do
      step = klass.from_params(params)
      @params.merge! params.permit(klass.params)
      @steps << step
      return if step.slug == slug || step.invalid? || step.final?

      klass = step.next_step_class
    end
  end

  def first_step
    steps.first
  end

  def current_step
    steps.last
  end

  def previous_step
    steps[-2]
  end

  def next_step
    current_step.next_step_class&.new
  end

  def first_step_path
    @paths.question first_step.slug
  end

  def current_step_path
    @paths.question current_slug, params
  end

  def previous_step_path
    if previous_slug.present?
      @paths.question previous_slug, params
    else
      start_path
    end
  end

  def next_step_path
    @paths.question next_slug, params
  end

  def form_path
    @paths.answer current_slug
  end

  def start_path
    @paths.home
  end

  delegate :slug, to: :current_step, prefix: :current, allow_nil: true
  delegate :slug, to: :previous_step, prefix: :previous, allow_nil: true
  delegate :slug, to: :next_step, prefix: :next, allow_nil: true

  delegate :template, :valid?, :invalid?, :errors, to: :current_step
end
