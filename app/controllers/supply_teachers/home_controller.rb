module SupplyTeachers
  class HomeController < FrameworkController
    before_action :authenticate_user!, except: :index
    before_action :authorize_user, except: :index
    before_action :set_end_of_journey, only: %i[temp_to_perm_fee fta_to_perm_fee]

    def index; end

    def temp_to_perm_fee
      journey = Journey.new(params[:slug], params)
      previous_step = journey.previous_step
      @back_path = journey.previous_step_path

      @calculator = TempToPermCalculator::Calculator.new(
        day_rate: previous_step.day_rate.to_i,
        days_per_week: previous_step.days_per_week.to_i,
        contract_start_date: previous_step.contract_start_date,
        hire_date: previous_step.hire_date,
        markup_rate: previous_step.markup_rate.to_f / 100.0,
        notice_date: previous_step.notice_date,
        holiday_1_start_date: previous_step.holiday_1_start_date,
        holiday_1_end_date: previous_step.holiday_1_end_date,
        holiday_2_start_date: previous_step.holiday_2_start_date,
        holiday_2_end_date: previous_step.holiday_2_end_date
      )
    end

    def fta_to_perm_fee
      journey = Journey.new(params[:slug], params)
      @previous_step = journey.previous_step
      @back_path = journey.previous_step_path

      @calculator = FTAToPermCalculator::Calculator.new(
        fixed_term_contract_fee: @previous_step.try(:fixed_term_fee).try(:to_i),
        current_contract_length: @previous_step.try(:current_contract_length).try(:to_f),
      )
    end
  end
end
