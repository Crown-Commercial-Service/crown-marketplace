class Journey
  attr_reader :steps, :params

  def initialize(first_step_class, slug, params, paths)
    @steps = []
    @params = HashWithIndifferentAccess.new
    @paths = paths

    klass = first_step_class
    loop do
      permitted = params.permit(klass.permit_list)
      step = klass.new(permitted)
      @params.merge! permitted
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

  def previous_questions_and_answers
    params.except(*current_step.class.permit_list)
  end

  def template
    [self.class.journey_name.underscore, current_step.template].join('/')
  end

  delegate :slug, to: :current_step, prefix: :current, allow_nil: true
  delegate :slug, to: :previous_step, prefix: :previous, allow_nil: true
  delegate :slug, to: :next_step, prefix: :next, allow_nil: true

  delegate :valid?, :errors, to: :current_step
  delegate :inputs, to: :current_step
end
