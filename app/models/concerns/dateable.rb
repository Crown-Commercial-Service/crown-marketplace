module Dateable
  def difference_in_months(start_date, end_date)
    start_date, end_date = end_date, start_date if start_date > end_date

    no_of_months = (end_date.year - start_date.year) * 12 + end_date.month - start_date.month - (end_date.day >= start_date.day ? 0 : 1)
    no_of_months + half_month(start_date, end_date, no_of_months)
  end

  def half_month(start_date, end_date, no_of_months)
    last_month = (start_date + no_of_months.months)
    no_of_extra_days = end_date - last_month
    no_of_extra_days >= no_of_days_for_half_month(last_month) ? 0.5 : 0
  end

  def no_of_days_for_half_month(date)
    date.month == 2 ? 14 : 15
  end
end
