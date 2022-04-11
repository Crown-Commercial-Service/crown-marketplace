module FacilitiesManagement
  module RM3830
    module Admin
      class SupplierDetailsController < FacilitiesManagement::Admin::FrameworkController
        def index
          @suppliers = SuppliersAdmin.select(:supplier_id, :supplier_name, :contact_email).order(:supplier_name)
        end
      end
    end
  end
end
