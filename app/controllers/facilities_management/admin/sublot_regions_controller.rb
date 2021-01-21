module FacilitiesManagement
  module Admin
    class SublotRegionsController < FacilitiesManagement::Admin::FrameworkController
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
      rescue_from NoMethodError, with: :render_no_method_error_response
      before_action :setup_supplier

      def render_unprocessable_entity_response(exception)
        logger.error exception.message
        redirect_to facilities_management_admin_path, flash: { error: 'Invalid supplier ID processing' }
      end

      def render_not_found_response(exception)
        logger.error exception.message
        redirect_to facilities_management_admin_path, flash: { error: 'Invalid supplier ID not found' }
      end

      def render_no_method_error_response(exception)
        logger.error exception.message
        redirect_to facilities_management_admin_path, flash: { error: 'Invalid supplier ID method not found' }
      end

      # uses one controller to show
      # all sublot region 1a, 1c, 1b
      # for suppliers
      def sublot_region
        # Get nuts regions
        @regions = Nuts1Region.all.map { |x| [x.code, x.name] }.to_h
        @supplier_lot = @supplier.lot_data[params['lot_type']]['regions']
        @sublot_region_name = 'Sub-lot ' + params['lot_type'] + ' regions'
        @selected_supplier_regions = FacilitiesManagement::Supplier::SupplierRegionsHelper.supllier_selected_regions(@supplier_lot)
        @subregions = FacilitiesManagement::Region.all.map { |x| [x.code, x.name] }.to_h
      end

      def update_sublot_regions
        @supplier.lot_data[params['lot_type']]['regions'] = params[:regions] || []
        @supplier.save
        redirect_to facilities_management_admin_supplier_framework_data_path
      end

      private

      def setup_supplier
        @supplier = FacilitiesManagement::Admin::SuppliersAdmin.find(params['id'])
      end
    end
  end
end
