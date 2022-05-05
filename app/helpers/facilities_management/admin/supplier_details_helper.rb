module FacilitiesManagement::Admin
  module SupplierDetailsHelper
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
      @suppliers_admin_module.find(params[:id]).supplier_name
    end

    def supplier_details_index_path
      case @framework
      when 'RM3830'
        facilities_management_rm3830_admin_supplier_details_path
      when 'RM6232'
        facilities_management_rm6232_admin_supplier_data_path
      end
    end
  end
end
