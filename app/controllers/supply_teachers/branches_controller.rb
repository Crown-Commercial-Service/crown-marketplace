module SupplyTeachers
  class BranchesController < FrameworkController
    SEARCH_RADIUSES = [50, 25, 10, 5, 1].freeze

    helper :telephone_number

    def index
      @journey = Journey.new(params[:slug], params)
      @back_path = @journey.previous_step_path

      if @journey.valid?
        render_branches
      else
        @form_path = @journey.form_path
        render @journey.template
      end
    end

    private

    def render_branches
      step = @journey.current_step
      @location = step.location
      @radius_in_miles = step.radius
      @alternative_radiuses = SEARCH_RADIUSES - [@radius_in_miles]
      @branches = step.branches daily_rates
      flash[:notice] = 'Calculated mark-up updated' if daily_rates.present? && !request.xhr?

      respond_to do |format|
        format.js { render json: @branches.find { |branch| params[:daily_rate][branch.id].present? } }
        format.html
        format.xlsx do
          spreadsheet = Spreadsheet.new(@branches, with_calculations: params[:calculations].present?)
          filename = "Shortlist of agencies#{params[:calculations].present? ? ' (with calculator)' : ''}"
          render xlsx: spreadsheet.to_xlsx, filename: filename
        end
      end
    end

    def daily_rates
      params[:daily_rate] || {}
    end
  end
end
