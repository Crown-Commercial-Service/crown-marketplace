module WorkingDays
  def self.working_days(number, start_date)
    first_working_day = start_date
    first_working_day = (first_working_day + 1.day).beginning_of_day while weekend?(first_working_day) || bank_holiday?(first_working_day)

    end_date = (first_working_day + number.days)
    dates = (first_working_day..end_date).to_a

    dates.each do |date|
      dates << (dates.last + 1.day) if weekend?(date) || bank_holiday?(date)
    end

    first_working_day == start_date ? dates.last : dates.last - (first_working_day.in_time_zone('London').utc_offset / 3600).hour
  end

  def self.weekend?(date)
    date.saturday? || date.sunday?
  end

  def self.bank_holiday?(date)
    date = date.to_date
    uk_bank_holidays.include? date
  end

  def self.uk_bank_holidays
    FacilitiesManagement::StaticData.bank_holidays.map { |country| country[1]['events'].map { |date| DateTime.parse(date['date']).in_time_zone('London') } }.flatten.uniq
  end
end
