class JourneyController < ApplicationController
  def question
    @journey = build_journey
    render_form
  end

  def answer
    @journey = build_journey
    if @journey.invalid?
      render_form
    else
      redirect_to @journey.next_step_path
    end
  end

  def render_form
    @form_path = @journey.form_path
    @back_path = if @journey.previous_slug.present?
                   @journey.back_path
                 else
                   homepage_path
                 end
    render @journey.template
  end

  def build_journey
    case params[:journey]
    when TeacherSupplyJourney.journey_name
      TeacherSupplyJourney.new(params[:slug], params)
    else
      raise ActionController::RoutingError
    end
  end
end
