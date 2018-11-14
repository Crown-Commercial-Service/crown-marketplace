class JourneyController < ApplicationController
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
    render @journey.template
  end

  def journey_class
    case params[:journey]
    when SupplyTeachers::Journey.journey_name
      SupplyTeachers::Journey
    when FacilitiesManagement::Journey.journey_name
      FacilitiesManagement::Journey
    when ManagementConsultancy::Journey.journey_name
      ManagementConsultancy::Journey
    when TempToPermCalculator::Journey.journey_name
      TempToPermCalculator::Journey
    else
      raise ActionController::RoutingError, nil
    end
  end

  def build_journey
    journey_class.new(params[:slug], params)
  end
end
