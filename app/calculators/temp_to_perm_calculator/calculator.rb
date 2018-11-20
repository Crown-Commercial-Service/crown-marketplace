require 'holidays'

module TempToPermCalculator
  class Calculator
    attr_reader :day_rate, :days_per_week, :contract_start_date, :hire_date, :markup_rate

    # rubocop:disable Metrics/ParameterLists
    def initialize(
      day_rate:,
      days_per_week:,
      contract_start_date:,
      hire_date:,
      markup_rate:,
      school_holidays:
    )
      @day_rate = day_rate
      @days_per_week = days_per_week
      @contract_start_date = contract_start_date
      @hire_date = hire_date
      @markup_rate = markup_rate
      @school_holidays = school_holidays
    end
    # rubocop:enable Metrics/ParameterLists

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
      end.count - @school_holidays
    end

    def fee_for_lack_of_notice?
      working_days_from_contract_start = (@contract_start_date..1.year.from_now).select do |day|
        day.on_weekday? && Holidays.on(day, :gb_eng).empty?
      end
      fortieth_working_day = working_days_from_contract_start.take(40).last

      @hire_date > fortieth_working_day
    end

    def fee_for_early_hire?
      working_days_from_contract_start = (@contract_start_date..1.year.from_now).select do |day|
        day.on_weekday? && Holidays.on(day, :gb_eng).empty?
      end
      sixtieth_working_day = working_days_from_contract_start.take(60).last

      @hire_date <= sixtieth_working_day
    end

    def ideal_hire_date
      working_days_from_contract_start = (@contract_start_date..1.year.from_now).select do |day|
        day.on_weekday? && Holidays.on(day, :gb_eng).empty?
      end
      working_days_from_contract_start.take(61).last
    end

    def ideal_notice_date
      working_days_from_contract_start = (@contract_start_date..1.year.from_now).select do |day|
        day.on_weekday? && Holidays.on(day, :gb_eng).empty?
      end
      working_days_from_contract_start.take(41).last
    end
  end
end
