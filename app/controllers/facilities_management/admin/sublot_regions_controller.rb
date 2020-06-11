module FacilitiesManagement
  module Admin
    class SublotRegionsController < FacilitiesManagement::FrameworkController
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
      rescue_from NoMethodError, with: :render_no_method_error_response

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
        h = {}
        Nuts1Region.all.each { |x| h[x.code] = x.name }
        @regions = h
        h = {}
        FacilitiesManagement::Region.all.each { |x| h[x.code] = x.name }
        @supplier = FacilitiesManagement::Admin::SuppliersAdmin.find(params['id'])
        @supplier_lot = @supplier.data['lots'].select { |lot| lot['lot_number'] == params['lot_type'] }
        @sublot_region_name = 'Sub-lot ' + params['lot_type'] + ' regions'
        @selected_supplier_regions = FacilitiesManagement::Supplier::SupplierRegionsHelper.supllier_selected_regions(@supplier_lot)
        @subregions = h
      end

      def update_sublot_regions
        @supplier = FacilitiesManagement::Admin::SuppliersAdmin.find(params['id'])
        @supplier.data['lots'].each do |lot|
          if lot['lot_number'] == params['lot_type']
            lot['regions'] = params[:regions].nil? ? [] : params[:regions]
          end
        end
        @supplier.save
        redirect_to facilities_management_admin_supplier_framework_data_path
      end
    end
  end
end
