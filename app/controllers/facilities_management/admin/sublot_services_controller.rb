module FacilitiesManagement
  module Admin
    class SublotServicesController < FacilitiesManagement::FrameworkController
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
      rescue_from NoMethodError, with: :render_no_method_error_response

      def render_unprocessable_entity_response(exception)
        logger.error exception.message
        redirect_to facilities_management_admin_path, flash: { error: 'Invalid supplier ID lot processing' }
      end

      def render_not_found_response(exception)
        logger.error exception.message
        redirect_to facilities_management_admin_path, flash: { error: 'Invalid supplier ID lot not found' }
      end

      def render_no_method_error_response(exception)
        logger.error exception.message
        redirect_to facilities_management_admin_path, flash: { error: 'Invalid supplier ID lot method not found' }
      end

      def index
        supplier_data = FacilitiesManagement::Admin::SuppliersAdmin.find(params[:id])['data']
        @supplier_name = supplier_data['supplier_name']
        @lot_name = 'Sub-lot ' + params[:lot] + ' services'
        lot_data = supplier_data['lots'].select { |data| data['lot_number'] == params[:lot] } .first
        supplier_services = lot_data['services']
        full_services
        setup_checkboxes(supplier_services)
      end

      def update
        supplier = FacilitiesManagement::Admin::SuppliersAdmin.find(params[:id])
        supplier.replace_services_for_lot(params[:checked_services], params[:lot])
        supplier.save
        redirect_to facilities_management_admin_supplier_framework_data_path
      end

      private

      def setup_checkboxes(supplier_services)
        @supplier_rate_data_checkboxes = {}
        @full_services.each do |service|
          service['work_package'].each do |work_pckg|
            code = work_pckg['code']
            @supplier_rate_data_checkboxes[code] = supplier_services.include?(code)
          end
        end
      end
    end
  end
end
