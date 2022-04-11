module FacilitiesManagement
  module RM6232
    module Admin
      class SupplierDataController < FacilitiesManagement::Admin::FrameworkController
        def index
          @suppliers = Supplier.order(:supplier_name).select(:id, :supplier_name)
        end
      end
    end
  end
end
