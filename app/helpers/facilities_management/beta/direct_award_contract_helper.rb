module FacilitiesManagement::Beta::DirectAwardContractHelper
  include FacilitiesManagement::Beta::RequirementsHelper

  def warning_title
    WARNINGS.each { |status, text| return text if @page_data[:procurement_data][:status] == status.to_s }
  end

  def warning_message
    warning_messages = { 'awaiting response': "This offer was sent on #{format_date_time(@page_data[:procurement_data][:contract_sent_date])}.",
                         'awaiting signature': '',
                         'signed': '',
                         'not-signed': '',
                         'declined': '',
                         'no response': '',
                         'closed': '' }
    warning_messages.each { |status, text| return text if @page_data[:procurement_data][:status] == status.to_s }
  end

  WARNINGS = { 'awaiting response': 'Sent', 'awaiting signature': '', 'signed': '', 'not-signed': '', 'declined': '', 'no response': '', 'closed': '' }.freeze
end
