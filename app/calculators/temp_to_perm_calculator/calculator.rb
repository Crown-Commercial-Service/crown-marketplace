require 'holidays'

module TempToPermCalculator
  class Calculator
    WORKING_DAYS_BEFORE_WHICH_EARLY_HIRE_FEE_CAN_BE_CHARGED = 60
    WORKING_DAYS_AFTER_WHICH_LATE_NOTICE_FEE_CAN_BE_CHARGED = 40
    DATE_NATIONAL_DEAL_BEGAN = Date.parse('23 Aug 2018')

    attr_reader :day_rate, :days_per_week, :contract_start_date, :hire_date, :markup_rate

    def initialize(
      day_rate:,
      days_per_week:,
      contract_start_date:,
      hire_date:,
      markup_rate:
    )
      @day_rate = day_rate
      @days_per_week = days_per_week
      @contract_start_date = contract_start_date
      @hire_date = hire_date
      @markup_rate = markup_rate
    end

    def early_hire_fee
      [
        daily_supplier_fee * chargeable_working_days * (@days_per_week / 5.0),
        0
      ].max
    end

    def chargeable_working_days
      WORKING_DAYS_BEFORE_WHICH_EARLY_HIRE_FEE_CAN_BE_CHARGED - working_days
    end

    def daily_supplier_fee
      @day_rate - (@day_rate / (1 + @markup_rate))
    end

    def working_days
      (@contract_start_date..@hire_date).select do |day|
        day != @hire_date &&
          day.on_weekday? &&
          Holidays.on(day, :gb_eng).empty?
      end.count
    end

    def fee_for_lack_of_notice?
      @hire_date > nth_working_day(WORKING_DAYS_AFTER_WHICH_LATE_NOTICE_FEE_CAN_BE_CHARGED)
    end

    def fee_for_early_hire?
      @hire_date <= nth_working_day(WORKING_DAYS_BEFORE_WHICH_EARLY_HIRE_FEE_CAN_BE_CHARGED)
    end

    def ideal_hire_date
      nth_working_day(WORKING_DAYS_BEFORE_WHICH_EARLY_HIRE_FEE_CAN_BE_CHARGED + 1)
    end

    def ideal_notice_date
      nth_working_day(WORKING_DAYS_AFTER_WHICH_LATE_NOTICE_FEE_CAN_BE_CHARGED + 1)
    end

    def before_national_deal_began?
      contract_start_date < DATE_NATIONAL_DEAL_BEGAN
    end

    private

    def nth_working_day(number_of_days)
      working_days_from_contract_start = (@contract_start_date..1.year.from_now).select do |day|
        day.on_weekday? && Holidays.on(day, :gb_eng).empty?
      end
      working_days_from_contract_start.take(number_of_days).last
    end
  end
end
