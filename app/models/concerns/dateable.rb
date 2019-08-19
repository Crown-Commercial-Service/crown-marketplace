module Dateable
  def difference_in_months(start_date, end_date)
    start_date, end_date = end_date, start_date if start_date > end_date

    no_of_months = (end_date.year - start_date.year) * 12 + end_date.month - start_date.month - (end_date.day >= start_date.day ? 0 : 1)
    no_of_months + half_month(start_date, end_date, no_of_months)
  end

  # no of days in the last month divided by no of extra days should be more or equal to 0.5
  # eg. 15/07 - 31/08 = 1 month and 16 days; 16/31 = 0.52 - this means 1.5 months
  def half_month(start_date, end_date, no_of_months)
    last_month = (start_date + no_of_months.months)
    no_of_extra_days = end_date - last_month

    no_of_extra_days / last_month.end_of_month.day.to_f >= 0.5 ? 0.5 : 0
  end
end
