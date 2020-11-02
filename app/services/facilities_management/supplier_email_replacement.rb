class FacilitiesManagement::SupplierEmailReplacement
  def initialize(email_replacements)
    @email_replacements = email_replacements
  end

  def replace
    @email_replacements.each do |email_set|
      next unless email_set.class == Array

      replace_supplier_email(email_set)
      replace_supplier_detail_email(email_set)
    end
  end

  private

  def replace_supplier_email(email_set)
    supplier = CCS::FM::Supplier.find_by(contact_email: email_set[0])

    return "supplier record not found found for #{email_set[0]}" if supplier.nil?

    supplier.update(contact_email: email_set[1])
    Rails.logger.info "updated email for #{supplier.contact_email}"
  end

  def replace_supplier_detail_email(email_set)
    supplier_detail = FacilitiesManagement::SupplierDetail.find_by(contact_email: email_set[0])

    return "supplier detail record not found for #{email_set[0]}" if supplier_detail.nil?

    supplier_detail.update(contact_email: email_set[1])

    Rails.logger.info "updated email for #{supplier_detail.name}"
  end
end
