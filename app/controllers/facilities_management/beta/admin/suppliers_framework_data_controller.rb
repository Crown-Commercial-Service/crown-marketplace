module FacilitiesManagement
  module Beta
    module Admin
      class SuppliersFrameworkDataController < FacilitiesManagement::Beta::FrameworkController
        def index
          @fm_suppliers = FacilitiesManagement::Admin::SuppliersAdmin.order("data ->'supplier_name' ASC")
        end
      end
    end
  end
end
