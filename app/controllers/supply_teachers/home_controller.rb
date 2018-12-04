module SupplyTeachers
  class HomeController < FrameworkController
    def index; end

    def fee
      journey = Journey.new(params[:slug], params)
      @back_path = journey.previous_step_path

      @calculator = TempToPermCalculator::Calculator.new(
        day_rate: params[:day_rate].to_i,
        days_per_week: params[:days_per_week].to_i,
        contract_start_date: contract_start_date,
        hire_date: hire_date,
        markup_rate: params[:markup_rate].to_f / 100.0
      )
    end

    private

    def contract_start_date
      Date.new(
        params[:contract_start_year].to_i,
        params[:contract_start_month].to_i,
        params[:contract_start_day].to_i
      )
    end

    def hire_date
      Date.new(
        params[:hire_date_year].to_i,
        params[:hire_date_month].to_i,
        params[:hire_date_day].to_i
      )
    end
  end
end
