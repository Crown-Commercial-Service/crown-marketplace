# rubocop:disable Metrics/ModuleLength, Metrics/MethodLength, Metrics/AbcSize
module FacilitiesManagement::PageDetail::RM3830::ContractDetails
  include FacilitiesManagement::PageDetail

  def page_details
    @page_details ||= page_definitions[:default].merge(page_definitions[@page_name])
  end

  def page_definitions
    @page_definitions ||= {
      default: {
        page_title: t("facilities_management.rm3830.procurements.contract_details.page_title.#{@page_name}"),
        caption1: @procurement.contract_name,
        continuation_text: 'Continue',
        return_url: facilities_management_rm3830_procurements_path,
        return_text: 'Return to procurement dashboard',
        secondary_name: 'return_to_results',
        secondary_text: 'Return to results',
        secondary_url: facilities_management_rm3830_procurements_path,
        back_text: 'Back',
        back_url: facilities_management_rm3830_procurements_path
      },
      pricing: {
        continuation_text: 'Continue to direct award'
      },
      what_next: {
        continuation_text: 'Continue to direct award'
      },
      important_information: {},
      contract_details: {},
      review_and_generate: {
        continuation_text: 'Generate documents'
      },
      review: {
        continuation_text: 'Create final contract and send to supplier'
      },
      sending: {
        continuation_text: 'Confirm and send contract to supplier',
        secondary_text: 'Cancel, return to review your contract',
        secondary_name: 'return_to_review'
      },
      payment_method: {
        back_url: facilities_management_rm3830_procurement_contract_details_path,
        continuation_text: 'Save and return',
        return_text: 'Return to contract details',
        return_url: facilities_management_rm3830_procurement_contract_details_path,
        back_text: 'Return to contract details'
      },
      invoicing_contact_details: {
        back_url: facilities_management_rm3830_procurement_contract_details_path,
        continuation_text: 'Continue',
        return_text: 'Return to contract details',
        return_url: facilities_management_rm3830_procurement_contract_details_path,
        back_text: 'Return to contract details'
      },
      new_invoicing_contact_details: {
        back_url: facilities_management_rm3830_procurement_contract_details_edit_path(page: 'invoicing_contact_details'),
        back_text: 'Return to invoicing contact details',
        continuation_text: 'Save and return',
        return_url: facilities_management_rm3830_procurement_contract_details_edit_path(page: 'invoicing_contact_details'),
        return_text: 'Return to invoicing contact details',
      },
      new_invoicing_contact_details_address: {
        back_url: facilities_management_rm3830_procurement_contract_details_edit_path(page: 'new_invoicing_contact_details'),
        back_text: 'Return to new invoicing contact details',
        page_title: 'Add address',
        return_url: facilities_management_rm3830_procurement_contract_details_edit_path(page: 'new_invoicing_contact_details'),
        return_text: 'Return to new invoicing contact details',
        caption3: @procurement[:contract_name],
        caption1: 'New invoicing contact details'
      },
      authorised_representative: {
        back_url: facilities_management_rm3830_procurement_contract_details_path,
        continuation_text: 'Continue',
        return_text: 'Return to contract details',
        return_url: facilities_management_rm3830_procurement_contract_details_path,
        back_text: 'Return to contract details'
      },
      new_authorised_representative: {
        back_url: facilities_management_rm3830_procurement_contract_details_edit_path(page: 'authorised_representative'),
        back_text: 'Return to authorised representative details',
        continuation_text: 'Save and return',
        return_url: facilities_management_rm3830_procurement_contract_details_edit_path(page: 'authorised_representative'),
        return_text: 'Return to authorised representative details',
      },
      new_authorised_representative_address: {
        back_url: facilities_management_rm3830_procurement_contract_details_edit_path(page: 'new_authorised_representative'),
        back_text: 'Return to new authorised representative details',
        return_url: facilities_management_rm3830_procurement_contract_details_edit_path(page: 'new_authorised_representative'),
        return_text: 'Return to new authorised representative details',
        caption3: @procurement[:contract_name],
        caption1: 'New authorised representative details'
      },
      notices_contact_details: {
        back_url: facilities_management_rm3830_procurement_contract_details_path,
        continuation_text: 'Continue',
        return_text: 'Return to contract details',
        return_url: facilities_management_rm3830_procurement_contract_details_path,
        back_text: 'Return to contract details'
      },
      new_notices_contact_details: {
        back_url: facilities_management_rm3830_procurement_contract_details_edit_path(page: 'notices_contact_details'),
        back_text: 'Return to notices contact details',
        continuation_text: 'Save and return',
        return_url: facilities_management_rm3830_procurement_contract_details_edit_path(page: 'notices_contact_details'),
        return_text: 'Return to notices contact details',
      },
      new_notices_contact_details_address: {
        back_url: facilities_management_rm3830_procurement_contract_details_edit_path(page: 'new_notices_contact_details'),
        back_text: 'Return to new notices contact details',
        return_url: facilities_management_rm3830_procurement_contract_details_edit_path(page: 'new_notices_contact_details'),
        return_text: 'Return to new notices contact details',
        caption3: @procurement[:contract_name],
        caption1: 'New notices contact details'
      },
      security_policy_document: {
        back_url: facilities_management_rm3830_procurement_contract_details_path,
        back_text: 'Return to contract details',
        continuation_text: 'Save and return',
        return_text: 'Return to contract details',
        return_url: facilities_management_rm3830_procurement_contract_details_path
      },
      local_government_pension_scheme: {
        back_url: facilities_management_rm3830_procurement_contract_details_path,
        back_text: 'Return to contract details',
        continuation_text: 'Save and continue',
        return_text: 'Return to contract details',
        return_url: facilities_management_rm3830_procurement_contract_details_path
      },
      pension_funds: {
        back_url: facilities_management_rm3830_procurement_contract_details_edit_path(page: 'local_government_pension_scheme'),
        back_text: 'Return to Local Government Pension Scheme',
        page_title: 'Pension funds',
        continuation_text: 'Save and return',
        return_text: 'Return to contract details',
        return_url: facilities_management_rm3830_procurement_contract_details_path
      },
      governing_law: {
        back_url: facilities_management_rm3830_procurement_contract_details_path,
        continuation_text: 'Save and continue',
        return_text: 'Return to contract details',
        return_url: facilities_management_rm3830_procurement_contract_details_path,
        back_text: 'Return to contract details'
      }
    }
  end
end
# rubocop:enable Metrics/ModuleLength, Metrics/MethodLength, Metrics/AbcSize
