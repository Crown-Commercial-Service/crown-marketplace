module FacilitiesManagement
  module Admin
    class SublotRegionsController < FacilitiesManagement::Admin::FrameworkController
      before_action :set_supplier, :set_lot, :redirect_if_lot_out_of_range
      before_action :set_region_data, only: :edit

      def edit; end

      def update
        @supplier.lot_data[@lot]['regions'] = params[:regions] || []
        @supplier.save
        redirect_to facilities_management_admin_supplier_framework_data_path
      end

      private

      def set_region_data
        @regions = Nuts1Region.all.map { |region| [region.code, region.name] }.to_h
        supplier_lot_data = @supplier.lot_data[@lot]['regions']
        @sublot_region_name = "Sub-lot #{@lot} regions"
        @selected_supplier_regions = FacilitiesManagement::Supplier::SupplierRegionsHelper.supllier_selected_regions(supplier_lot_data)
        @subregions = FacilitiesManagement::Region.all.map { |region| [region.code, region.name] }.to_h
      end
    end
  end
end
