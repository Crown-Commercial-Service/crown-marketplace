require 'supply_teachers/journey'

module SupplyTeachers
  class BranchesController < ApplicationController
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
      @alternative_radiuses = [1, 5, 10, 25] - [@radius_in_miles]
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
end
