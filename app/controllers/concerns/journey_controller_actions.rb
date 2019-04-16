module JourneyControllerActions
  extend ActiveSupport::Concern

  included do
    helper :journey
  end

  def start
    redirect_to build_journey.first_step_path
  end

  def question
    @journey = build_journey
    render_form
  end

  def answer
    @journey = build_journey
    if @journey.valid?
      redirect_to @journey.next_step_path
    else
      render_form
    end
  end

  private

  def render_form
    @form_path = @journey.form_path
    @back_path = @journey.previous_step_path
    byebug
    render @journey.template
  end

  def build_journey
    journey_class.new(params[:slug], params)
  end
end
