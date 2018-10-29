class BranchesController < ApplicationController
  def index
    @journey = build_journey
    @back_path = @journey.back_path

    if @journey.invalid?
      @form_path = @journey.form_path
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

  def build_journey
    case params[:journey]
    when TeacherSupplyJourney.journey_name
      TeacherSupplyJourney.new(params[:slug], params)
    else
      raise ActionController::RoutingError
    end
  end
end
