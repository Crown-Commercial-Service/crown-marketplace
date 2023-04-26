module FacilitiesManagement
  module RM3830
    module Admin
      class SublotRegionsController < FacilitiesManagement::Admin::FrameworkController
        before_action :set_supplier, :set_lot, :redirect_if_lot_out_of_range
        before_action :set_region_data, only: :show

        def show; end

        private

        def set_region_data
          @regions = Nuts1Region.all.to_h { |region| [region.code, region.name] }
          supplier_lot_data = @supplier.lot_data[@lot]['regions']
          @sublot_region_name = "Sub-lot #{@lot} regions"
          @selected_supplier_regions = SupplierRegionsHelper.supllier_selected_regions(supplier_lot_data)
          @subregions = FacilitiesManagement::Region.all.to_h { |region| [region.code, region.name] }
        end
      end
    end
  end
end
