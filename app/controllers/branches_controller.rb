class BranchesController < ApplicationController
  def index
    @journey = TeacherSupplyJourney.new(params[:slug], params)
    @back_path = search_question_path(slug: @journey.previous_slug, params: @journey.params)

    if @journey.invalid?
      @form_path = search_answer_path(slug: @journey.current_slug)
      render "search/#{@journey.template}"
    else
      render_branches
    end
  end

  private

  def render_branches
    step = @journey.current_step
    @location = step.location
    @branches = step.branches

    respond_to do |format|
      format.html
      format.xlsx do
        spreadsheet = Spreadsheet.new(@branches, with_calculations: params[:calculations].present?)
        render xlsx: spreadsheet.to_xlsx, filename: 'branches'
      end
    end
  end
end
