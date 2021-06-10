module FacilitiesManagement::RM3830::Admin::SupplierDetailsHelper
  def contact_detail(attribute, supplier = @supplier)
    supplier[attribute].presence || 'None'
  end

  def full_address
    @supplier.full_address.presence || 'None'
  end

  def supplier_user_email
    @supplier.user&.email || 'None'
  end

  def current_supplier_name
    FacilitiesManagement::Admin::SuppliersAdmin.find(params[:id]).supplier_name
  end
end
