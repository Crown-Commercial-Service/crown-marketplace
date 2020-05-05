module FacilitiesManagement::Procurements::ContractsHelper
  include FacilitiesManagement::ProcurementsHelper

  def warning_title
    if @contract.closed?
      'Closed'
    else
      WARNINGS[@contract.aasm_state.to_sym]
    end
  end

  # rubocop:disable Metrics/AbcSize
  def warning_message
    warning_messages = { sent: "#{t('facilities_management.procurements.contracts_helper.warning_message.sent_1')} #{format_date_time(@contract.contract_expiry_date)}.<br/> #{t('facilities_management.procurements.contracts_helper.warning_message.sent_2')}",
                         accepted: t('facilities_management.procurements.contracts_helper.warning_message.accepted'),
                         signed: "#{t('facilities_management.procurements.contracts_helper.warning_message.signed')} #{format_date(@contract.contract_start_date)} and #{format_date(@contract.contract_end_date)}.",
                         not_signed: "#{t('facilities_management.procurements.contracts_helper.warning_message.not_signed_1')} #{format_date_time @contract.contract_signed_date} #{t('facilities_management.procurements.contracts_helper.warning_message.not_signed_2')}.",
                         declined: "#{t('facilities_management.procurements.contracts_helper.warning_message.declined')} #{format_date_time(@contract.supplier_response_date)}.",
                         expired: t('facilities_management.procurements.contracts_helper.warning_message.expired') }
    if @contract.closed?
      if !@contract.reason_for_closing.nil?
        "#{t('facilities_management.procurements.contracts_helper.warning_message.closed')} #{format_date_time(@contract.contract_closed_date)}."
      elsif @contract.last_offer?
        "#{t('facilities_management.procurements.contracts_helper.warning_message.last_closed_1')} #{format_date_time(@contract.contract_closed_date)} #{t('facilities_management.procurements.contracts_helper.warning_message.last_closed_2')}"
      else
        "#{t('facilities_management.procurements.contracts_helper.warning_message.last_closed_3')} #{format_date_time(@contract.contract_closed_date)}."
      end
    else
      warning_messages[@contract.aasm_state.to_sym]
    end
  end
  # rubocop:enable Metrics/AbcSize

  WARNINGS = { sent: 'Sent',
               accepted: 'Accepted, awaiting contract signature',
               signed: 'Accepted and signed',
               not_signed: 'Accepted, not signed',
               declined: 'Declined',
               expired: 'Not responded' }.freeze

  def page_details(action)
    action = 'edit' if action == 'update'
    @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
  end

  def show_continuation_text
    case @contract.aasm_state
    when 'accepted'
      'Confirm if contract signed or not'
    when 'not_signed', 'declined', 'expired'
      "View next supplier's price"
    end
  end

  def show_secondary_text
    if @contract.closed? || @contract.aasm_state == 'signed'
      'Make a copy of your requirements'
    else
      'Close this procurement'
    end
  end

  def edit_secondary_text
    if params['name'] == 'next_supplier'
      'Cancel and return to contract summary'
    else
      'Cancel'
    end
  end

  def edit_page_title
    if params['name'] == 'next_supplier'
      'Offer to next supplier'
    else
      'Confirmation of signed contract'
    end
  end

  def page_definitions
    @page_definitions ||= {
      default: {
        back_label: 'Back',
        back_text: 'Back',
        back_url: facilities_management_procurements_path,
        caption1: @procurement.contract_name,
        return_text: 'Return to procurements dashboard',
        return_url: facilities_management_procurements_path,
      },
      show: {
        page_title: 'Contract summary',
        continuation_text: show_continuation_text,
        return_text: 'Return to procurements dashboard',
        secondary_text: show_secondary_text,
      },
      edit: {
        back_url: facilities_management_procurement_contract_path(@procurement),
        page_title: edit_page_title,
        continuation_text: 'Close this procurement',
        secondary_text: edit_secondary_text,
      },
    }.freeze
  end
end
