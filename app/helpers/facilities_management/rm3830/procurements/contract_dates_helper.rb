module FacilitiesManagement::RM3830::Procurements::ContractDatesHelper
  def initial_call_off_period
    period_to_string(@procurement.initial_call_off_period_years, @procurement.initial_call_off_period_months)
  end

  def mobilisation_period
    @procurement.mobilisation_period_required ? pluralize(@procurement.mobilisation_period, 'week') : 'None'
  end

  def optional_call_off_extensions_period(optional_call_off_extension)
    period_to_string(optional_call_off_extension.years, optional_call_off_extension.months)
  end

  def initial_call_off_period_description
    format_date_period(@procurement.initial_call_off_start_date, @procurement.initial_call_off_end_date)
  end

  def mobilisation_period_description
    format_date_period(@procurement.mobilisation_start_date, @procurement.mobilisation_end_date)
  end

  def extension_period_description(period)
    format_date_period(@procurement.extension_period_start_date(period), @procurement.extension_period_end_date(period))
  end

  def date_of_first_indexation
    @procurement.initial_call_off_period < 1.year ? 'Not applicable' : format_date(@procurement.initial_call_off_start_date.next_year)
  end

  def period_to_string(years, months)
    years_text = years.positive? ? pluralize(years, 'year') : nil
    months_text = months.positive? ? pluralize(months, 'month') : nil

    [years_text, months_text].compact.join(' and ')
  end

  def format_date_period(start_date, end_date)
    "#{format_date start_date} to #{format_date end_date}"
  end
end
