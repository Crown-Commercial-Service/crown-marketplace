class SearchController < ApplicationController
  def question
    @journey = TeacherSupplyJourney.new(params[:slug], params)
    @form_path = search_answer_path(slug: @journey.current_slug)
    @back_path = if @journey.previous_slug.present?
                   search_question_path(slug: @journey.previous_slug, params: @journey.params)
                 else
                   homepage_path
                 end
    render @journey.template
  end

  def answer
    @journey = TeacherSupplyJourney.new(params[:slug], params)
    if @journey.invalid?
      @form_path = search_answer_path(slug: @journey.current_slug)
      @back_path = if @journey.previous_slug.present?
                     search_question_path(slug: @journey.previous_slug, params: @journey.params)
                   else
                     homepage_path
                   end
      render @journey.template
    else
      redirect_to @journey.next_step_path
    end
  end
end
