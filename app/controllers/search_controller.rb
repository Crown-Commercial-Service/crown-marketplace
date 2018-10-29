class SearchController < ApplicationController
  def question
    @journey = TeacherSupplyJourney.new(params[:slug], params)
    @form_path = @journey.form_path
    @back_path = if @journey.previous_slug.present?
                   @journey.back_path
                 else
                   homepage_path
                 end
    render @journey.template
  end

  def answer
    @journey = TeacherSupplyJourney.new(params[:slug], params)
    if @journey.invalid?
      @form_path = @journey.form_path
      @back_path = if @journey.previous_slug.present?
                     @journey.back_path
                   else
                     homepage_path
                   end
      render @journey.template
    else
      redirect_to @journey.next_step_path
    end
  end
end
