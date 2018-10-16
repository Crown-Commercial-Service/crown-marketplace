class BranchesController < ApplicationController
  def index
    @back_path = school_postcode_question_path(
      params.permit(:postcode, :nominated_worker, :hire_via_agency)
    )

    if params[:postcode].nil?
      @branches = Branch.includes(:supplier).all
      return
    end

    location = Location.new(params[:postcode])
    @postcode = location.postcode
    @point = location.point

    unless location.valid?
      display_error('Postcode is invalid')
      return
    end

    unless @point
      display_error("Couldn't find that postcode")
      return
    end

    @branches = Branch.search(@point)
  end

  private

  def display_error(message)
    path = school_postcode_question_path(
      params.permit(:postcode, :nominated_worker, :hire_via_agency)
    )
    redirect_to path, flash: { error: message }
  end
end
