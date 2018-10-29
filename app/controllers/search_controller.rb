class SearchController < ApplicationController
  def question
    @journey = build_journey
    @form_path = search_answer_path(slug: @journey.current_slug)
    @back_path = if @journey.previous_slug.present?
                   search_question_path(slug: @journey.previous_slug, params: @journey.params)
                 else
                   homepage_path
                 end
    render @journey.template
  end

  def answer
    @journey = build_journey
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

  private

  def build_journey
    TeacherSupplyJourney.new(params[:slug], params)
  end
end
