module FacilitiesManagement::Beta::RequirementsHelper
  def initial_call_off_period_start_date
    @page_data[:procurement_data][:initial_call_off_start_date]
  end

  def initial_call_off_period_end_date
    Date.parse(@page_data[:procurement_data][:initial_call_off_start_date].to_s).next_year(@page_data[:procurement_data][:initial_call_off_period]) - 1
  end

  def mobilisation_start_date
    start_date = Date.parse(@page_data[:procurement_data][:initial_call_off_start_date].to_s) - 1
    start_date -= (@page_data[:procurement_data][:mobilisation_period]. * 7)
    start_date
  end

  def mobilisation_end_date
    Date.parse(@page_data[:procurement_data][:initial_call_off_start_date].to_s) - 1
  end

  def format_extension(start_date, end_date)
    "#{format_date start_date} to #{format_date end_date}"
  end

  def mobilisation_period_description
    format_extension(mobilisation_start_date, mobilisation_end_date)
  end

  def initial_call_off_period_description
    format_extension(initial_call_off_period_start_date, initial_call_off_period_end_date)
  end

  def extension_one_description
    extension_one_start_date = @page_data[:procurement_data][:initial_call_off_start_date].next_year(@page_data[:procurement_data][:initial_call_off_period])
    extension_one_end_date = extension_one_start_date.next_year(@page_data[:procurement_data][:optional_call_off_extensions_1]) - 1
    format_extension extension_one_start_date, extension_one_end_date
  end

  def extension_two_description
    extension_one_start_date = @page_data[:procurement_data][:initial_call_off_start_date].next_year(@page_data[:procurement_data][:initial_call_off_period])
    start_date = extension_one_start_date.next_year(@page_data[:procurement_data][:optional_call_off_extensions_1])
    end_date = (start_date - 1).next_year(@page_data[:procurement_data][:optional_call_off_extensions_2])
    format_extension start_date, end_date
  end

  def extension_three_description
    extension_one_start_date = @page_data[:procurement_data][:initial_call_off_start_date].next_year(@page_data[:procurement_data][:initial_call_off_period])
    start_date = extension_one_start_date.next_year(@page_data[:procurement_data][:optional_call_off_extensions_1] + +@page_data[:procurement_data][:optional_call_off_extensions_2])
    end_date = (start_date - 1).next_year(@page_data[:procurement_data][:optional_call_off_extensions_3])
    format_extension start_date, end_date
  end

  def extension_four_description
    extension_one_start_date = @page_data[:procurement_data][:initial_call_off_start_date].next_year(@page_data[:procurement_data][:initial_call_off_period])
    start_date = extension_one_start_date.next_year(@page_data[:procurement_data][:optional_call_off_extensions_1] + @page_data[:procurement_data][:optional_call_off_extensions_2] + @page_data[:procurement_data][:optional_call_off_extensions_3])
    end_date = (start_date - 1).next_year(@page_data[:procurement_data][:optional_call_off_extensions_4])
    format_extension start_date, end_date
  end

  def to_lower_case(str)
    str[0] = str[0].downcase
    str
  end
end
