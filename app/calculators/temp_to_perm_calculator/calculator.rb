require 'holidays'

module TempToPermCalculator
  class Calculator
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
      60 - working_days
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
      @hire_date > nth_working_day(40)
    end

    def fee_for_early_hire?
      @hire_date <= nth_working_day(60)
    end

    def ideal_hire_date
      nth_working_day(61)
    end

    def ideal_notice_date
      nth_working_day(41)
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
