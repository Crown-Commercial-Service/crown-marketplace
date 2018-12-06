module SupplyTeachers
  class HomeController < FrameworkController
    require_permission :none, only: :index

    def index; end

    def fee
      journey = Journey.new(params[:slug], params)
      previous_step = journey.previous_step
      @back_path = journey.previous_step_path

      @calculator = TempToPermCalculator::Calculator.new(
        day_rate: previous_step.day_rate.to_i,
        days_per_week: previous_step.days_per_week.to_i,
        contract_start_date: previous_step.contract_start_date,
        hire_date: previous_step.hire_date,
        markup_rate: previous_step.markup_rate.to_f / 100.0
      )
    end
  end
end
