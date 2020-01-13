module FacilitiesManagement::Beta::Supplier::SupplierAccountHelper
  # include FacilitiesManagement::Beta::ProcurementsHelper

  def format_date(date_object)
    date_object&.strftime '%e %B %Y'
  end

  def format_date_time(date_object)
    date_object&.strftime '%e %B %Y, %l:%M%P'
  end

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

  def accepted_page
    ['accepted', 'live', 'not signed', 'withdrawn']
  end

  def to_lower_case(str)
    str[0] = str[0].downcase
    str
  end

  def warning_title
    WARNINGS.each { |status, text| return text if @page_data[:procurement_data][:status] == status.to_s }
  end

  def warning_message
    warning_messages = { 'received': "This contract offer expires on #{format_date_time(@page_data[:procurement_data][:expiration_date])}.",
                         'accepted': 'Awaiting buyer confirmation of signed contract.',
                         'declined': "You declined this contract offer on #{format_date_time(@page_data[:procurement_data][:date_responded_to_contract])}.",
                         'live': "Your contract starts on #{format_date(@page_data[:procurement_data][:initial_call_off_start_date])} and ends on #{format_date(@page_data[:procurement_data][:initial_call_off_end_date])}.",
                         'not responded': "You did not respond to this contract offer within the required timescales,<br/> therefore it was automatically declined with the reason of 'no response'.",
                         'not signed': "The buyer has recorded this contract as 'not signed' on #{format_date_time(@page_data[:procurement_data][:date_contract_closed])}. <br> The contract offer has therefore been closed.",
                         'withdrawn': "The buyer withdrew this contract offer and closed this procurement on <br/> #{format_date_time(@page_data[:procurement_data][:date_contract_closed])}." }
    warning_messages.each { |status, text| return text if @page_data[:procurement_data][:status] == status.to_s }
  end

  WARNINGS = { 'received': 'Received contract offer', 'accepted': 'Accepted', 'live': 'Accepted and signed', 'declined': 'Declined', 'not responded': 'Not responded', 'not signed': 'Not signed', 'withdrawn': 'Withdrawn' }.freeze
end
