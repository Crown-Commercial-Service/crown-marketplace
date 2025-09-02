module WorkingDays
  def self.working_days(number, start_date)
    first_working_day = start_date
    first_working_day = (first_working_day + 1.day).beginning_of_day while weekend?(first_working_day) || bank_holiday?(first_working_day)

    end_date = first_working_day
    number_of_days = 0

    while number_of_days < number
      end_date += 1.day
      number_of_days += 1 unless weekend?(end_date) || bank_holiday?(end_date)
    end

    first_working_day == start_date ? end_date : end_date - (first_working_day.in_time_zone('London').utc_offset / 3600).hour
  end

  def self.weekend?(date)
    date.saturday? || date.sunday?
  end

  def self.bank_holiday?(date)
    BankHoliday.bank_holiday?(date)
  end
end
