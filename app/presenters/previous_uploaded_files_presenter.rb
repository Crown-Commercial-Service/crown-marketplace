class PreviousUploadedFilesPresenter
  def current_accredited_suppliers
    @current_accredited_suppliers ||= previous_uploaded_file(:current_accredited_suppliers)
  end

  def current_accredited_suppliers_url
    @current_accredited_suppliers_url ||= previous_uploaded_file_object(:current_accredited_suppliers).current_accredited_suppliers_url
  end

  def geographical_data_all_suppliers
    @geographical_data_all_suppliers ||= previous_uploaded_file(:geographical_data_all_suppliers)
  end

  def geographical_data_all_suppliers_url
    @geographical_data_all_suppliers_url ||= previous_uploaded_file_object(:geographical_data_all_suppliers).geographical_data_all_suppliers_url
  end

  def lot_1_and_lot_2_comparisons
    @lot_1_and_lot_2_comparisons ||= previous_uploaded_file(:lot_1_and_lot_2_comparisons)
  end

  def lot_1_and_lot_2_comparisons_url
    @lot_1_and_lot_2_comparisons_url ||= previous_uploaded_file_object(:lot_1_and_lot_2_comparisons).lot_1_and_lot_2_comparisons_url
  end

  def master_vendor_contacts
    @master_vendor_contacts ||= previous_uploaded_file(:master_vendor_contacts)
  end

  def master_vendor_contacts_url
    @master_vendor_contacts_url ||= previous_uploaded_file_object(:master_vendor_contacts).master_vendor_contacts_url
  end

  def neutral_vendor_contacts
    @neutral_vendor_contacts ||= previous_uploaded_file(:neutral_vendor_contacts)
  end

  def neutral_vendor_contacts_url
    @neutral_vendor_contacts_url ||= previous_uploaded_file_object(:neutral_vendor_contacts).neutral_vendor_contacts_url
  end

  def pricing_for_tool
    @pricing_for_tool ||= previous_uploaded_file(:pricing_for_tool)
  end

  def pricing_for_tool_url
    @pricing_for_tool_url ||= previous_uploaded_file_object(:pricing_for_tool).pricing_for_tool_url
  end

  def supplier_lookup
    @supplier_lookup ||= previous_uploaded_file(:supplier_lookup)
  end

  def supplier_lookup_url
    @supplier_lookup_url ||= previous_uploaded_file_object(:supplier_lookup).supplier_lookup_url
  end

  private

  def previous_uploaded_file(attr_name)
    SupplyTeachers::Admin::Upload.previous_uploaded_file(attr_name)
  end

  def previous_uploaded_file_object(attr_name)
    SupplyTeachers::Admin::Upload.previous_uploaded_file_object(attr_name)
  end
end
