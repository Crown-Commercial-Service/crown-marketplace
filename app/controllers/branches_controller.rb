class BranchesController < ApplicationController
  def index
    @back_path = school_postcode_question_path(
      params.permit(:postcode, :nominated_worker, :hire_via_agency)
    )

    if params[:postcode].nil?
      @branches = Branch.includes(:supplier).all
    else
      @location = Location.new(params[:postcode])

      unless @location.valid?
        display_error(@location.error)
        return
      end

      @branches = Branch.search(@location.point)
    end

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: Spreadsheet.new(@branches).to_xlsx, filename: 'branches' }
    end
  end

  private

  def display_error(message)
    path = school_postcode_question_path(
      params.permit(:postcode, :nominated_worker, :hire_via_agency)
    )
    redirect_to path, flash: { error: message }
  end
end
