class JourneyController < ApplicationController
  def index
    redirect_to build_journey.first_step_path
  end

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

  private

  def render_form
    @form_path = @journey.form_path
    @back_path = @journey.back_path
    render @journey.template
  end

  def journey_class
    case params[:journey]
    when TeacherSupplyJourney.journey_name
      TeacherSupplyJourney
    when FacilitiesManagementJourney.journey_name
      FacilitiesManagementJourney
    else
      raise ActionController::RoutingError
    end
  end

  def build_journey
    journey_class.new(params[:slug], params)
  end
end
