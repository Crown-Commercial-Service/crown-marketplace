module FacilitiesManagement::Beta::ProcurementsHelper
  def journey_step_url_former(journey_step:, region_codes: nil, service_codes: nil)
    "/facilities-management/choose-#{journey_step}?#{{ region_codes: region_codes }.to_query}&#{{ service_codes: service_codes }.to_query}"
  end

  def format_date(date_object)
    date_object.strftime ('%d %B %Y').to_s
  end

  def initial_call_off_period_start_date(date)
    start_date = Date.parse(date.to_s)
    format_date(start_date)
  end

  def initial_call_off_period_end_date(initial_call_off_period_start_date, initial_call_off_period)
    end_date = Date.parse(initial_call_off_period_start_date.to_s).next_year(initial_call_off_period) - 1
    format_date(end_date)
  end

  def mobilisation_start_date(initial_call_off_period_start_date, mobilisation_period)
    start_date = Date.parse(initial_call_off_period_start_date.to_s) - (mobilisation_period * 7)
    format_date(start_date)
  end

  def mobilisation_end_date(initial_call_off_period_start_date)
    end_date = Date.parse(initial_call_off_period_start_date.to_s) - 1
    format_date(end_date)
  end
end
