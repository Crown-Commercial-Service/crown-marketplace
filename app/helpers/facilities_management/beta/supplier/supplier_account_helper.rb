module FacilitiesManagement::Beta::Supplier::SupplierAccountHelper
  include FacilitiesManagement::Beta::RequirementsHelper

  def accepted_page
    ['accepted', 'live', 'not signed', 'withdrawn']
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
