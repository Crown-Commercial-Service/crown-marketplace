require_relative '../admin'

module Pages::RM6232
  class LotData < SitePrism::Section
    section :'lot status', 'dl > div:nth-child(1)' do
      element :status, 'dd.govuk-summary-list__value'
      element :change_link, 'dd.govuk-summary-list__actions > a'
    end
    section :services, 'dl > div:nth-child(2)' do
      elements :names, 'details > div > ul > li'
      element :change_link, 'dd.govuk-summary-list__actions > a'
    end
    section :regions, 'dl > div:nth-child(3)' do
      elements :names, 'details > div > ul > li'
      element :change_link, 'dd.govuk-summary-list__actions > a'
    end
  end

  class ChangesRow < SitePrism::Section
    element :attribute, 'th'
    element :prev_value, 'td:nth-of-type(1)'
    element :new_value, 'td:nth-of-type(2)'
  end

  class Admin < Pages::Admin
    sections :suppliers, '#fm-table-filter > tbody > tr', visible: true do
      element :supplier_name, 'th'
      element :'View details', 'td:nth-child(2) > a'
      element :'View lot data', 'td:nth-child(3) > a'
    end

    element :supplier_search_input, '#fm-table-filter-input'

    element :supplier_name_sub_title, '#main-content > div:nth-child(1) > div > span'

    sections :lot_data_tables, '.lot-data-table' do
      element :title, 'h2'
    end

    section :supplier_detail_form, 'main form' do
      element :'Supplier name', '#facilities_management_rm6232_admin_suppliers_admin_supplier_name'
      element :'DUNS number', '#facilities_management_rm6232_admin_suppliers_admin_duns'
      element :'Company registration number', '#facilities_management_rm6232_admin_suppliers_admin_registration_number'
    end

    section :lot_data, '#main-content' do
      section :lot_1a, LotData, '#lot-data_table--lot-1a'
      section :lot_1b, LotData, '#lot-data_table--lot-1b'
      section :lot_1c, LotData, '#lot-data_table--lot-1c'
      section :lot_2a, LotData, '#lot-data_table--lot-2a'
      section :lot_2b, LotData, '#lot-data_table--lot-2b'
      section :lot_2c, LotData, '#lot-data_table--lot-2c'
      section :lot_3a, LotData, '#lot-data_table--lot-3a'
      section :lot_3b, LotData, '#lot-data_table--lot-3b'
      section :lot_3c, LotData, '#lot-data_table--lot-3c'
    end

    element :active_true, '#facilities_management_rm6232_admin_suppliers_admin_active_true'
    element :active_false, '#facilities_management_rm6232_admin_suppliers_admin_active_false'

    element :lot_active_true, '#facilities_management_rm6232_supplier_lot_data_active_true'
    element :lot_active_false, '#facilities_management_rm6232_supplier_lot_data_active_false'

    section :log_table, '#main-content > div:nth-child(3) > div > table' do
      elements :log_rows, 'tbody > tr'
    end

    element :updated_supplier, '#updated-supplier'
    element :updated_by_email, '#updated-by-email'
    element :uploaded_by_email, '#main-content > div:nth-child(1) > div > dl > div:nth-child(3) > dd'
    element :updated_lot, '#updated-lot'

    section :changes_table, '#main-content > div:nth-child(4) > div > table' do
      sections :changes_rows, ChangesRow, 'tbody > tr'
    end

    section :lot_status_changes_table, '#main-content > div:nth-child(3) > div > table' do
      sections :changes_rows, ChangesRow, 'tbody > tr'
    end

    elements :added_items, '#added-items > li'
    elements :removed_items, '#removed-items > li'

    section :management_report, 'main form' do
      element :'From day', '#facilities_management_rm6232_admin_management_report_start_date_dd'
      element :'From month', '#facilities_management_rm6232_admin_management_report_start_date_mm'
      element :'From year', '#facilities_management_rm6232_admin_management_report_start_date_yyyy'

      element :'To day', '#facilities_management_rm6232_admin_management_report_end_date_dd'
      element :'To month', '#facilities_management_rm6232_admin_management_report_end_date_mm'
      element :'To year', '#facilities_management_rm6232_admin_management_report_end_date_yyyy'
    end
  end
end
