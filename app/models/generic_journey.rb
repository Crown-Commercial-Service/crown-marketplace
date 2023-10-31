class GenericJourney
  attr_reader :steps, :params

  def initialize(first_step_class, framework, slug, params, paths)
    @steps = []
    @params = ActionController::Parameters.new
    @paths = paths
    @framework = framework
    @slug = slug

    klass = first_step_class
    permitted_params = Set.new

    loop do
      permitted_params.merge(klass.permit_list)
      step = klass.new(params.permit(klass.permit_list))
      @steps << step
      break if step.slug == slug || step.invalid? || step.final?

      klass = step.next_step_class
    end

    @params = params.permit(permitted_params.to_a)
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
    @paths.question @framework, first_step.slug
  end

  def current_step_path
    @paths.question @framework, current_slug, params
  end

  def previous_step_path
    if previous_slug.present?
      @paths.question @framework, previous_slug, params
    else
      start_path
    end
  end

  def previous_step_text
    PREVIOUS_STEP_TEXT[@framework][@slug]
  end

  def next_step_path
    @paths.question @framework, next_slug, params
  end

  def form_path
    @paths.answer @framework, current_slug
  end

  def start_path
    @paths.home
  end

  def previous_questions_and_answers
    return params if current_step.final? || current_step.try(:all_keys_needed?)

    params.except(*current_step.class.permitted_keys)
  end

  def template
    [self.class.journey_name.underscore, @framework.downcase, current_step.template].join('/')
  end

  delegate :slug, to: :current_step, prefix: :current, allow_nil: true
  delegate :slug, to: :previous_step, prefix: :previous, allow_nil: true
  delegate :slug, to: :next_step, prefix: :next, allow_nil: true

  delegate :valid?, :errors, to: :current_step
  delegate :inputs, to: :current_step

  PREVIOUS_STEP_TEXT = {
    'RM3830' => {
      'choose-services' => 'Return to your account',
      'choose-locations' => 'Return to services'
    },
    'RM6232' => {
      'choose-services' => 'Return to your account',
      'choose-locations' => 'Return to services',
      'annual-contract-value' => 'Return to regions'
    }
  }.freeze
end
