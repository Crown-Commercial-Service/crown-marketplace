module FacilitiesManagement
  module RM6378
    module Admin
      class SupplierDataController < FacilitiesManagement::Admin::FrameworkController
        def index
          @suppliers = Supplier.order(:name).select(:id, :name)
        end
      end
    end
  end
end
