class BranchesController < ApplicationController
  def index
    @back_path = search_question_path(slug: journey.previous_slug, params: journey.params)

    if journey.invalid?
      redirect_to(
        search_question_path(slug: journey.current_slug, params: journey.params),
        flash: { error: journey.error }
      )
      return
    end

    render_branches
  end

  private

  def render_branches
    step = journey.current_step
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

  def journey
    @journey ||= TeacherSupplyJourney.new(params[:slug], params)
  end

  def safe_params
    journey.params
  end
  helper_method :safe_params
end
