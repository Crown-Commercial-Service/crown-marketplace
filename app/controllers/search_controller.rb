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
      flash.now[:error] = @journey.error
      render @journey.template
    else
      redirect_to next_step_path
    end
  end

  private

  def next_step_path
    case @journey.next_slug
    when 'results'
      branches_path(params: @journey.params)
    when 'master-vendor-managed-service'
      master_vendors_path(@journey.params)
    when 'neutral-vendor-managed-service'
      neutral_vendors_path(@journey.params)
    else
      search_question_path(slug: @journey.next_slug, params: @journey.params)
    end
  end

  def build_journey
    first_step_class = Steps::LookingFor
    Journey.new(first_step_class, params[:slug], params)
  end
end
