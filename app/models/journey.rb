class Journey
  attr_reader :steps, :params

  def initialize(first_step_class, slug, params)
    @steps = []
    @params = {}

    klass = first_step_class
    loop do
      step = klass.from_params(params)
      @params.merge! params.permit(klass.params)
      @steps << step
      return if step.slug == slug || step.invalid? || step.final?

      klass = step.next_step_class
    end
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

  delegate :slug, to: :current_step, prefix: :current, allow_nil: true
  delegate :slug, to: :previous_step, prefix: :previous, allow_nil: true
  delegate :slug, to: :next_step, prefix: :next, allow_nil: true

  delegate :template, :valid?, :invalid?, to: :current_step

  def error
    current_step.errors.full_messages.to_sentence
  end
end
