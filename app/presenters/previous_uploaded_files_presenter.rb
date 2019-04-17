class PreviousUploadedFilesPresenter

  def current_accredited_suppliers
    @current_accredited_suppliers ||= previous_uploaded_file(:current_accredited_suppliers)
  end

  def geographical_data_all_suppliers
    @geographical_data_all_suppliers ||= previous_uploaded_file(:geographical_data_all_suppliers)
  end

  def lot_1_and_lot_2_comparisons
    @lot_1_and_lot_2_comparisons ||= previous_uploaded_file(:lot_1_and_lot_2_comparisons)
  end

  def master_vendor_contacts
    @master_vendor_contacts ||= previous_uploaded_file(:master_vendor_contacts)
  end

  def neutral_vendor_contacts
    @neutral_vendor_contacts ||= previous_uploaded_file(:neutral_vendor_contacts)
  end

  def pricing_for_tool
    @pricing_for_tool ||= previous_uploaded_file(:pricing_for_tool)
  end

  def supplier_lookup
    @supplier_lookup ||= previous_uploaded_file(:supplier_lookup)
  end

  private

  def previous_uploaded_file(attr_name)
    SupplyTeachers::Admin::Upload.previous_uploaded_file(attr_name)
  end
end