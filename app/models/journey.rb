# rubocop:disable Rails/Delegate
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

  def current_slug
    current_step.slug
  end

  def previous_slug
    previous_step&.slug
  end

  def next_slug
    next_step&.slug
  end

  def template
    current_step.template
  end

  def invalid?
    current_step.invalid?
  end

  def error
    current_step.errors.full_messages.to_sentence
  end
end
# rubocop:enable Rails/Delegate
