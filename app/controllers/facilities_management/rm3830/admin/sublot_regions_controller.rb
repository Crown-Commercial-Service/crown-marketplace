module FacilitiesManagement
  module RM3830
    module Admin
      class SublotRegionsController < FacilitiesManagement::Admin::FrameworkController
        before_action :set_framework_has_expired
        before_action :redirect_if_framework_has_expired, only: :update
        before_action :set_supplier, :set_lot, :redirect_if_lot_out_of_range
        before_action :set_region_data, only: :edit

        def edit; end

        def update
          @supplier.lot_data[@lot]['regions'] = params[:regions] || []
          @supplier.save
          redirect_to facilities_management_rm3830_admin_supplier_framework_data_path
        end

        private

        def set_region_data
          @regions = Nuts1Region.all.to_h { |region| [region.code, region.name] }
          supplier_lot_data = @supplier.lot_data[@lot]['regions']
          @sublot_region_name = "Sub-lot #{@lot} regions"
          @selected_supplier_regions = SupplierRegionsHelper.supllier_selected_regions(supplier_lot_data)
          @subregions = FacilitiesManagement::Region.all.to_h { |region| [region.code, region.name] }
        end

        def redirect_if_framework_has_expired
          redirect_to edit_facilities_management_rm3830_admin_supplier_framework_datum_sublot_region_path if @framework_has_expired
        end
      end
    end
  end
end
