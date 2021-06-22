module Pages
  class Contract < SitePrism::Page
    element :supplier_name, 'form > table:nth-of-type(1) > tbody > tr:nth-child(2) > td'

    section :supplier_contact_details, 'form > div > div > table' do
      element :supplier_name, 'tbody > tr:nth-child(2) > th'
      element :details, '#contact-details-drop-down > details > div'
    end

    element :warning_text, 'div.govuk-warning-text > strong'
    element :key_details, 'h2.govuk-heading-s'
    element :contract_offer_history, '#contract-offer-history > details > div'
    element :reason_for_not_signing, '#reason-for-not-signing  > details > div'
    element :reason_for_closing, '#reason-for-closing  > details > div'
    element :reason_for_declining, '#reason-for-declining  > details > div'

    section :contract_option, '#main-content' do
      element :contract_signed_yes, '#facilities_management_procurement_supplier_contract_signed_true'
      element :contract_signed_no, '#facilities_management_procurement_supplier_contract_signed_false'
      element :reason_for_not_signing, '#facilities_management_procurement_supplier_reason_for_not_signing'

      element :contract_start_date_day, '#facilities_management_procurement_supplier_contract_start_date_dd'
      element :contract_start_date_month, '#facilities_management_procurement_supplier_contract_start_date_mm'
      element :contract_start_date_year, '#facilities_management_procurement_supplier_contract_start_date_yyyy'

      element :contract_end_date_day, '#facilities_management_procurement_supplier_contract_end_date_dd'
      element :contract_end_date_month, '#facilities_management_procurement_supplier_contract_end_date_mm'
      element :contract_end_date_year, '#facilities_management_procurement_supplier_contract_end_date_yyyy'

      element :reason_for_closing, '#facilities_management_procurement_supplier_reason_for_closing'
    end

    section :contract_signed_page, '#main-content' do
      element :contract_dates, 'div.govuk-body.govuk-\!-margin-bottom-5'
    end

    elements :what_happens_next_details_titles, '#what-happens-next-details .govuk-details__summary-text'
    elements :what_happens_next_list_titles, '#what-happens-next-list strong'
    element :contract_summary_footer, '#contract-summary-footer'
  end
end
