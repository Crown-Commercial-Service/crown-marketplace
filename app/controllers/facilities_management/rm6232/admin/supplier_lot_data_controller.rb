module FacilitiesManagement
  module RM6232
    module Admin
      class SupplierLotDataController < FacilitiesManagement::Admin::FrameworkController
        before_action :set_supplier_data, only: :show

        def show
          @suppliers = Supplier.order(:supplier_name).select(:id, :supplier_name)
        end

        private

        def set_supplier_data
          @supplier = Supplier.find(params[:id])
          @lot_data = @supplier.lot_data.order(:lot_code).map do |lot_data|
            {
              id: lot_data.id,
              lot_code: lot_data.lot_code,
              service_names: lot_data.services.map(&:name),
              region_names: lot_data.regions.map(&:name)
            }
          end
        end
      end
    end
  end
end
