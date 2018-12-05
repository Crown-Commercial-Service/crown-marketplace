require 'holidays'

module TempToPermCalculator
  class Calculator
    WORKING_DAYS_BEFORE_WHICH_EARLY_HIRE_FEE_CAN_BE_CHARGED = 60
    WORKING_DAYS_AFTER_WHICH_LATE_NOTICE_FEE_CAN_BE_CHARGED = 40
    WORKING_DAYS_NOTICE_PERIOD_REQUIRED_TO_AVOID_LATE_NOTICE_FEE = 20
    MAXIMUM_NUMBER_OF_WORKING_DAYS_PER_WEEK = 5
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
        chargeable_working_days * working_day_supplier_fee,
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
        day != @hire_date && working_day?(day)
      end.count
    end

    def fee_for_lack_of_notice?
      @hire_date >= late_notice_fee_can_be_charged_from
    end

    def fee_for_early_hire?
      @hire_date <= early_hire_fee_can_be_charged_until
    end

    def ideal_hire_date
      working_days_after(early_hire_fee_can_be_charged_until, 1)
    end

    def ideal_notice_date
      working_days_before(ideal_hire_date, WORKING_DAYS_NOTICE_PERIOD_REQUIRED_TO_AVOID_LATE_NOTICE_FEE)
    end

    def before_national_deal_began?
      contract_start_date < DATE_NATIONAL_DEAL_BEGAN
    end

    private

    def working_day_supplier_fee
      daily_supplier_fee * (@days_per_week / MAXIMUM_NUMBER_OF_WORKING_DAYS_PER_WEEK.to_f)
    end

    def late_notice_fee_can_be_charged_from
      working_days_after(@contract_start_date, WORKING_DAYS_AFTER_WHICH_LATE_NOTICE_FEE_CAN_BE_CHARGED)
    end

    def early_hire_fee_can_be_charged_until
      working_days_after(@contract_start_date, WORKING_DAYS_BEFORE_WHICH_EARLY_HIRE_FEE_CAN_BE_CHARGED - 1)
    end

    def working_days_after(date, number_of_days)
      working_days_count = 0
      until working_days_count == number_of_days
        date += 1
        working_days_count += 1 if working_day?(date)
      end
      date
    end

    def working_days_before(date, number_of_days)
      working_days_count = 0
      until working_days_count == number_of_days
        date -= 1
        working_days_count += 1 if working_day?(date)
      end
      date
    end

    def working_day?(date)
      date.on_weekday? && Holidays.on(date, :gb_eng).empty?
    end
  end
end
