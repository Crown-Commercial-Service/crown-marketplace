module Dateable
  def difference_in_months(start_date, end_date)
    start_date, end_date = end_date, start_date if start_date > end_date

    (end_date.year - start_date.year) * 12 + end_date.month - start_date.month - (end_date.day >= start_date.day ? 0 : 1)
  end
end
